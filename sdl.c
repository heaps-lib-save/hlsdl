#define HL_NAME(n) sdl_##n

#include <hl.h>
#include <locale.h>

#if defined(_WIN32) || defined(__ANDROID__) || defined(HL_IOS) || defined(HL_TVOS)
#	include <SDL3/SDL.h>
#	include <SDL3/SDL_vulkan.h>
#else
#	include <SDL3/SDL.h>
#endif

#if defined (HL_IOS) || defined(HL_TVOS)
#	include <OpenGLES/ES3/gl.h>
#	include <OpenGLES/ES3/glext.h>
#endif

#ifndef SDL_MAJOR_VERSION
#	error "SDL3 SDK not found"
#endif

#if SDL_MAJOR_VERSION < 3
#	error "This library requires SDL3. Please use SDL3 headers."
#endif

#define TWIN _ABSTRACT(sdl_window)
#define TGL _ABSTRACT(sdl_gl)

typedef struct {
	int x;
	int y;
	int w;
	int h;
	int style;
} wsave_pos;

typedef enum {
	Quit,
	MouseMove,
	MouseLeave,
	MouseDown,
	MouseUp,
	MouseWheel,
	WindowState,
	KeyDown,
	KeyUp,
	TextInput,
	GControllerAdded = 100,
	GControllerRemoved,
	GControllerDown,
	GControllerUp,
	GControllerAxis,
	TouchDown = 200,
	TouchUp,
	TouchMove,
	JoystickAxisMotion = 300,
	JoystickBallMotion,
	JoystickHatMotion,
	JoystickButtonDown,
	JoystickButtonUp,
	JoystickAdded,
	JoystickRemoved,
	DropStart = 400,
	DropFile,
	DropText,
	DropEnd,
} event_type;

typedef enum {
	Show,
	Hide,
	Expose,
	Move,
	Resize,
	Minimize,
	Maximize,
	Restore,
	Enter,
	Leave,
	Focus,
	Blur,
	Close
} ws_change;

typedef struct {
	hl_type *t;
	event_type type;
	int mouseX;
	int mouseY;
	int mouseXRel;
	int mouseYRel;
	int button;
	int wheelDelta;
	ws_change state;
	int keyCode;
	int scanCode;
	bool keyRepeat;
	int reference;
	int value;
	int __unused;
	int window;
	vbyte* dropFile;
} event_data;

static bool isGlOptionsSet = false;

HL_PRIM bool HL_NAME(init_once)() {
	SDL_SetHint(SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS, "1");
	if( !SDL_Init(SDL_INIT_EVERYTHING) ) {
		hl_error("SDL_Init failed: %s", hl_to_utf16(SDL_GetError()));
		return false;
	}
	setlocale(LC_ALL, "C");
#	ifdef _WIN32
	// Set the internal windows timer period to 1ms (will give accurate sleep for vsync)
	timeBeginPeriod(1);
#	endif
	// default GL parameters — request latest, SDL gives nearest match
	if (!isGlOptionsSet) {
#ifdef HL_MOBILE
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES);
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2);
#else
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 4);
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 6);
#endif
		SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
		SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE, 8);
		SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
	}

	return true;
}

HL_PRIM void HL_NAME(gl_options)( int major, int minor, int depth, int stencil, int flags, int samples ) {
	isGlOptionsSet = true;
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, major);
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, minor);
	SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, depth);
	SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE, stencil);
	SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, (flags&1));
	if( flags&2 )
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
	else if( flags&4 )
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_COMPATIBILITY);
	else if( flags&8 )
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES);
	else {
#ifdef HL_MOBILE
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES);
#else
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
#endif
	}

	if (samples > 1) {
		SDL_GL_SetAttribute(SDL_GL_MULTISAMPLEBUFFERS, 1);
		SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES, samples);
	}
}

HL_PRIM bool HL_NAME(hint_value)( vbyte* name, vbyte* value) {
	return SDL_SetHint((char*)name, (char*)value);
}

HL_PRIM int HL_NAME(event_poll)( SDL_Event *e ) {
	return SDL_PollEvent(e);
}

HL_PRIM bool HL_NAME(event_loop)( event_data *event ) {
	while (true) {
		SDL_Event e;
		if (!SDL_PollEvent(&e)) break;
		switch (e.type) {
		case SDL_EVENT_QUIT:
			event->type = Quit;
			break;
		case SDL_EVENT_MOUSE_MOTION:
			event->type = MouseMove;
			event->window = e.motion.windowID;
			event->mouseX = (int)e.motion.x;
			event->mouseY = (int)e.motion.y;
			event->mouseXRel = (int)e.motion.xrel;
			event->mouseYRel = (int)e.motion.yrel;
			break;
		case SDL_EVENT_KEY_DOWN:
			event->type = KeyDown;
			event->window = e.key.windowID;
			event->keyCode = e.key.key;
			event->scanCode = e.key.scancode;
			event->keyRepeat = e.key.repeat;
			break;
		case SDL_EVENT_KEY_UP:
			event->type = KeyUp;
			event->window = e.key.windowID;
			event->keyCode = e.key.key;
			event->scanCode = e.key.scancode;
			break;
		case SDL_EVENT_MOUSE_BUTTON_DOWN:
			event->type = MouseDown;
			event->window = e.button.windowID;
			event->button = e.button.button;
			event->mouseX = (int)e.button.x;
			event->mouseY = (int)e.button.y;
			break;
		case SDL_EVENT_MOUSE_BUTTON_UP:
			event->type = MouseUp;
			event->window = e.button.windowID;
			event->button = e.button.button;
			event->mouseX = (int)e.button.x;
			event->mouseY = (int)e.button.y;
			break;
		case SDL_EVENT_FINGER_DOWN:
			event->type = TouchDown;
			event->mouseX = (int)(e.tfinger.x*10000);
			event->mouseY = (int)(e.tfinger.y*10000);
			event->reference = (int)e.tfinger.fingerID;
			break;
		case SDL_EVENT_FINGER_MOTION:
			event->type = TouchMove;
			event->mouseX = (int)(e.tfinger.x*10000);
			event->mouseY = (int)(e.tfinger.y*10000);
			event->reference = (int)e.tfinger.fingerID;
			break;
		case SDL_EVENT_FINGER_UP:
			event->type = TouchUp;
			event->mouseX = (int)(e.tfinger.x*10000);
			event->mouseY = (int)(e.tfinger.y*10000);
			event->reference = (int)e.tfinger.fingerID;
			break;
		case SDL_EVENT_MOUSE_WHEEL:
			event->type = MouseWheel;
			event->window = e.wheel.windowID;
			event->wheelDelta = e.wheel.y;
			if (e.wheel.direction == SDL_MOUSEWHEEL_FLIPPED) event->wheelDelta *= -1;
			event->mouseX = (int)e.wheel.x;
			event->mouseY = (int)e.wheel.y;
			break;
		case SDL_EVENT_WINDOW_RESIZED:
		case SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED:
		case SDL_EVENT_WINDOW_METAL_VIEW_RESIZED:
		case SDL_EVENT_WINDOW_SAFE_AREA_CHANGED:
		case SDL_EVENT_WINDOW_OCCLUDED:
		case SDL_EVENT_WINDOW_EXPOSED:
		case SDL_EVENT_WINDOW_MOUSE_LEAVE:
		case SDL_EVENT_WINDOW_MOUSE_ENTER:
		case SDL_EVENT_WINDOW_MINIMIZED:
		case SDL_EVENT_WINDOW_MAXIMIZED:
		case SDL_EVENT_WINDOW_RESTORED:
		case SDL_EVENT_WINDOW_TAKE_FOCUS:
		case SDL_EVENT_WINDOW_HIT_TEST:
		case SDL_EVENT_WINDOW_ICCPROF_CHANGED:
		case SDL_EVENT_WINDOW_DISPLAY_CHANGED:
		case SDL_EVENT_WINDOW_HDR_STATE_CHANGED:
		case SDL_EVENT_WINDOW_SHOWN:
		case SDL_EVENT_WINDOW_HIDDEN:
		case SDL_EVENT_WINDOW_MOVED:
		case SDL_EVENT_WINDOW_FOCUS_GAINED:
		case SDL_EVENT_WINDOW_FOCUS_LOST:
		case SDL_EVENT_WINDOW_CLOSE_REQUESTED:
		case SDL_EVENT_WINDOW_ENTER_FULLSCREEN:
		case SDL_EVENT_WINDOW_LEAVE_FULLSCREEN:
			event->type = WindowState;
			event->window = e.window.windowID;
			switch (e.type) {
			case SDL_EVENT_WINDOW_SHOWN:
				event->state = Show;
				break;
			case SDL_EVENT_WINDOW_HIDDEN:
				event->state = Hide;
				break;
			case SDL_EVENT_WINDOW_EXPOSED:
				event->state = Expose;
				break;
			case SDL_EVENT_WINDOW_MOVED:
				event->state = Move;
				break;
			case SDL_EVENT_WINDOW_RESIZED:
			case SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED:
				event->state = Resize;
				break;
			case SDL_EVENT_WINDOW_MINIMIZED:
				event->state = Minimize;
				break;
			case SDL_EVENT_WINDOW_MAXIMIZED:
				event->state = Maximize;
				break;
			case SDL_EVENT_WINDOW_RESTORED:
				event->state = Restore;
				break;
			case SDL_EVENT_WINDOW_MOUSE_ENTER:
				event->state = Enter;
				break;
			case SDL_EVENT_WINDOW_MOUSE_LEAVE:
				event->state = Leave;
				break;
			case SDL_EVENT_WINDOW_FOCUS_GAINED:
				event->state = Focus;
				break;
			case SDL_EVENT_WINDOW_FOCUS_LOST:
				event->state = Blur;
				break;
			case SDL_EVENT_WINDOW_CLOSE_REQUESTED:
				event->state = Close;
				break;
			default:
				continue;
			}
			break;
		case SDL_EVENT_TEXT_INPUT:
			event->type = TextInput;
			event->window = e.text.windowID;
			event->keyCode = *(int*)e.text.text;
			event->keyCode &= e.text.text[0] ? e.text.text[1] ? e.text.text[2] ? e.text.text[3] ? 0xFFFFFFFF : 0xFFFFFF : 0xFFFF : 0xFF : 0;
			break;
		case SDL_EVENT_GAMEPAD_ADDED:
			event->type = GControllerAdded;
			event->reference = e.gdevice.which;
			break;
		case SDL_EVENT_GAMEPAD_REMOVED:
			event->type = GControllerRemoved;
			event->reference = e.gdevice.which;
			break;
		case SDL_EVENT_GAMEPAD_BUTTON_DOWN:
			event->type = GControllerDown;
			event->reference = e.gbutton.which;
			event->button = e.gbutton.button;
			break;
		case SDL_EVENT_GAMEPAD_BUTTON_UP:
			event->type = GControllerUp;
			event->reference = e.gbutton.which;
			event->button = e.gbutton.button;
			break;
		case SDL_EVENT_GAMEPAD_AXIS_MOTION:
			event->type = GControllerAxis;
			event->reference = e.gaxis.which;
			event->button = e.gaxis.axis;
			event->value = e.gaxis.value;
			break;
		case SDL_EVENT_JOYSTICK_AXIS_MOTION:
			event->type = JoystickAxisMotion;
			event->reference = e.jaxis.which;
			event->button = e.jaxis.axis;
			event->value = e.jaxis.value;
			break;
		case SDL_EVENT_JOYSTICK_BALL_MOTION:
			event->type = JoystickBallMotion;
			event->reference = e.jball.which;
			event->button = e.jball.ball;
			event->mouseXRel = e.jball.xrel;
			event->mouseYRel = e.jball.yrel;
			break;
		case SDL_EVENT_JOYSTICK_HAT_MOTION:
			event->type = JoystickHatMotion;
			event->reference = e.jhat.which;
			event->button = e.jhat.hat;
			event->value = e.jhat.value;
			break;
		case SDL_EVENT_JOYSTICK_BUTTON_DOWN:
			event->type = JoystickButtonDown;
			event->reference = e.jbutton.which;
			event->button = e.jbutton.button;
			break;
		case SDL_EVENT_JOYSTICK_BUTTON_UP:
			event->type = JoystickButtonUp;
			event->reference = e.jbutton.which;
			event->button = e.jbutton.button;
			break;
		case SDL_EVENT_JOYSTICK_ADDED:
			event->type = JoystickAdded;
			event->reference = e.jdevice.which;
			break;
		case SDL_EVENT_JOYSTICK_REMOVED:
			event->type = JoystickRemoved;
			event->reference = e.jdevice.which;
			break;
		case SDL_EVENT_DROP_BEGIN:
			event->type = DropStart;
			event->window = e.drop.windowID;
			break;
		case SDL_EVENT_DROP_FILE:
		case SDL_EVENT_DROP_TEXT: {
			vbyte* bytes = hl_copy_bytes(e.drop.data, (int)strlen(e.drop.data) + 1);
			SDL_free(e.drop.data);
			event->type = e.type == SDL_EVENT_DROP_FILE ? DropFile : DropText;
			event->dropFile = bytes;
			event->window = e.drop.windowID;
			break;
		}
		case SDL_EVENT_DROP_COMPLETE:
			event->type = DropEnd;
			event->window = e.drop.windowID;
			break;
		default:
			continue;
		}
		return true;
	}
	return false;
}

HL_PRIM void HL_NAME(quit)() {
	SDL_Quit();
#	ifdef _WIN32
	timeEndPeriod(1);
#	endif
}

HL_PRIM void HL_NAME(delay)( int time ) {
	hl_blocking(true);
	SDL_Delay(time);
	hl_blocking(false);
}

HL_PRIM int HL_NAME(get_screen_width)() {
	const SDL_DisplayMode *e = SDL_GetCurrentDisplayMode(SDL_GetPrimaryDisplay());
	if (e) return e->w;
	return 0;
}

HL_PRIM int HL_NAME(get_screen_height)() {
	const SDL_DisplayMode *e = SDL_GetCurrentDisplayMode(SDL_GetPrimaryDisplay());
	if (e) return e->h;
	return 0;
}

HL_PRIM int HL_NAME(get_screen_width_of_window)(SDL_Window* win) {
	SDL_DisplayID displayID = win != NULL ? SDL_GetDisplayForWindow(win) : SDL_GetPrimaryDisplay();
	const SDL_DisplayMode *e = SDL_GetCurrentDisplayMode(displayID);
	if (e) return e->w;
	return 0;
}

HL_PRIM int HL_NAME(get_screen_height_of_window)(SDL_Window* win) {
	SDL_DisplayID displayID = win != NULL ? SDL_GetDisplayForWindow(win) : SDL_GetPrimaryDisplay();
	const SDL_DisplayMode *e = SDL_GetCurrentDisplayMode(displayID);
	if (e) return e->h;
	return 0;
}

HL_PRIM int HL_NAME(get_framerate)(SDL_Window* win) {
	SDL_DisplayID displayID = win != NULL ? SDL_GetDisplayForWindow(win) : SDL_GetPrimaryDisplay();
	const SDL_DisplayMode *e = SDL_GetCurrentDisplayMode(displayID);
	if (e) return (int)e->refresh_rate;
	return 0;
}

HL_PRIM void HL_NAME(message_box)(vbyte *title, vbyte *text, bool error) {
	hl_blocking(true);
	SDL_ShowSimpleMessageBox(error ? SDL_MESSAGEBOX_ERROR : 0, (char*)title, (char*)text, NULL);
	hl_blocking(false);
}


HL_PRIM void HL_NAME(set_vsync)(bool v) {
	SDL_GL_SetSwapInterval(v ? 1 : 0);
}

HL_PRIM bool HL_NAME(detect_win32)() {
#	ifdef _WIN32
	return true;
#	else
	return false;
#	endif
}

HL_PRIM void HL_NAME(text_input)( bool enable ) {
	if( enable )
		SDL_StartTextInput();
	else
		SDL_StopTextInput();
}

HL_PRIM bool HL_NAME(set_relative_mouse_mode)(bool enable) {
	return SDL_SetWindowRelativeMouseMode(SDL_GL_GetCurrentWindow(), enable);
}

HL_PRIM bool HL_NAME(get_relative_mouse_mode)() {
	SDL_Window *win = SDL_GL_GetCurrentWindow();
	if (win)
		return SDL_GetWindowRelativeMouseMode(win);
	return false;
}

HL_PRIM bool HL_NAME(warp_mouse_global)(int x, int y) {
	return SDL_WarpMouseGlobal((float)x, (float)y);
}

HL_PRIM void HL_NAME(warp_mouse_in_window)(SDL_Window* window, int x, int y) {
	SDL_WarpMouseInWindow(window, (float)x, (float)y);
}

HL_PRIM void HL_NAME(set_window_grab)(SDL_Window* window, bool grabbed) {
	SDL_SetWindowMouseGrab(window, grabbed);
}

HL_PRIM bool HL_NAME(get_window_grab)(SDL_Window* window) {
	return SDL_GetWindowMouseGrab(window);
}

HL_PRIM int HL_NAME(get_global_mouse_state)(int* x, int* y) {
	float fx, fy;
	SDL_MouseButtonFlags buttons = SDL_GetGlobalMouseState(&fx, &fy);
	*x = (int)fx;
	*y = (int)fy;
	return (int)buttons;
}

HL_PRIM const char *HL_NAME(detect_keyboard_layout)() {
	char q = (char)SDL_GetKeyFromScancode(SDL_SCANCODE_Q, KMOD_NONE, false);
	char w = (char)SDL_GetKeyFromScancode(SDL_SCANCODE_W, KMOD_NONE, false);
	char y = (char)SDL_GetKeyFromScancode(SDL_SCANCODE_Y, KMOD_NONE, false);

	if (q == 'q' && w == 'w' && y == 'y') return "qwerty";
	if (q == 'a' && w == 'z' && y == 'y') return "azerty";
	if (q == 'q' && w == 'w' && y == 'z') return "qwertz";
	if (q == 'q' && w == 'z' && y == 'y') return "qzerty";
	return "unknown";
}

#define TWIN _ABSTRACT(sdl_window)
DEFINE_PRIM(_BOOL, init_once, _NO_ARG);
DEFINE_PRIM(_VOID, gl_options, _I32 _I32 _I32 _I32 _I32 _I32);
DEFINE_PRIM(_BOOL, event_loop, _DYN );
DEFINE_PRIM(_I32, event_poll, _STRUCT );
DEFINE_PRIM(_VOID, quit, _NO_ARG);
DEFINE_PRIM(_VOID, delay, _I32);
DEFINE_PRIM(_I32, get_screen_width, _NO_ARG);
DEFINE_PRIM(_I32, get_screen_height, _NO_ARG);
DEFINE_PRIM(_I32, get_screen_width_of_window, TWIN);
DEFINE_PRIM(_I32, get_screen_height_of_window, TWIN);
DEFINE_PRIM(_I32, get_framerate, TWIN);
DEFINE_PRIM(_VOID, message_box, _BYTES _BYTES _BOOL);
DEFINE_PRIM(_VOID, set_vsync, _BOOL);
DEFINE_PRIM(_BOOL, detect_win32, _NO_ARG);
DEFINE_PRIM(_VOID, text_input, _BOOL);
DEFINE_PRIM(_BOOL, set_relative_mouse_mode, _BOOL);
DEFINE_PRIM(_BOOL, get_relative_mouse_mode, _NO_ARG);
DEFINE_PRIM(_BOOL, warp_mouse_global, _I32 _I32);
DEFINE_PRIM(_VOID, warp_mouse_in_window, TWIN _I32 _I32);
DEFINE_PRIM(_VOID, set_window_grab, TWIN _BOOL);
DEFINE_PRIM(_BOOL, get_window_grab, TWIN);
DEFINE_PRIM(_I32, get_global_mouse_state, _REF(_I32) _REF(_I32));
DEFINE_PRIM(_BYTES, detect_keyboard_layout, _NO_ARG);
DEFINE_PRIM(_BOOL, hint_value, _BYTES _BYTES);

// Window

HL_PRIM SDL_Window *HL_NAME(win_create_ex)(int x, int y, int width, int height, int sdlFlags) {
	// force window to match device resolution on mobile
	if ((sdlFlags & (
#ifdef HL_MAC
		SDL_WINDOW_METAL | 
#endif
		SDL_WINDOW_VULKAN )) == 0) {
		sdlFlags |= SDL_WINDOW_OPENGL;
	}

#ifdef	HL_MOBILE
	SDL_Window* win = SDL_CreateWindow("", width, height, SDL_WINDOW_BORDERLESS | sdlFlags);
#else
	SDL_Window* win = SDL_CreateWindow("", width, height, sdlFlags);
	if (win) {
		SDL_SetWindowPosition(win, x, y);
	}
#endif
#	ifdef HL_WIN
	// force window to show even if the debugger force process windows to be hidden
	if( win && (SDL_GetWindowFlags(win) & SDL_WINDOW_INPUT_FOCUS) == 0 ) {
		SDL_HideWindow(win);
		SDL_ShowWindow(win);
	}
	if (win) SDL_RaiseWindow(win); // better first focus lost behavior
#	endif
	return win;
}

HL_PRIM SDL_Window *HL_NAME(win_create)(int width, int height) {
	return HL_NAME(win_create_ex)(SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, width, height, 0);
}

HL_PRIM SDL_GLContext HL_NAME(win_get_glcontext)(SDL_Window *win) {
	SDL_GLContext ctx = SDL_GL_CreateContext(win);
	
#ifndef HL_MOBILE
	if (!ctx) {
		// requested GL version not available; progressively fall back
		int desktop_fallback[][2] = {
			{4, 5}, {4, 4}, {4, 3}, {4, 2}, {4, 1}, {4, 0},
			{3, 3}, {3, 2}
		};
		for (int i = 0; i < sizeof(desktop_fallback)/sizeof(desktop_fallback[0]); i++) {
			SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, desktop_fallback[i][0]);
			SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, desktop_fallback[i][1]);
			ctx = SDL_GL_CreateContext(win);
			if (ctx) break;
		}
	}
	// last resort: compatibility profile
	if (!ctx) {
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_COMPATIBILITY);
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2);
		ctx = SDL_GL_CreateContext(win);
	}
#else
	if (!ctx) {
		// ES 3.2 -> 3.1 -> 3.0 fallback
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 1);
		ctx = SDL_GL_CreateContext(win);
	}
	if (!ctx) {
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 0);
		ctx = SDL_GL_CreateContext(win);
	}
#endif
	
	return ctx;
}

HL_PRIM bool HL_NAME(win_set_fullscreen)(SDL_Window *win, int mode) {
	switch( mode ) {
	case 0: // WINDOWED
		return SDL_SetWindowFullscreen(win, false);
	case 1: // FULLSCREEN
	{
		// In SDL3, we set fullscreen mode first, then toggle fullscreen
		SDL_DisplayID displayID = SDL_GetDisplayForWindow(win);
		const SDL_DisplayMode *dmode = SDL_GetCurrentDisplayMode(displayID);
		if (dmode) {
			SDL_SetWindowFullscreenMode(win, dmode);
		}
		return SDL_SetWindowFullscreen(win, true);
	}
	case 2: // BORDERLESS
		// SDL3: borderless fullscreen desktop mode
		SDL_SetWindowFullscreenMode(win, NULL);
		return SDL_SetWindowFullscreen(win, true);
	}
	return false;
}

HL_PRIM bool HL_NAME(win_set_display_mode)(SDL_Window *win, int width, int height, int framerate) {
	SDL_DisplayID displayID = SDL_GetDisplayForWindow(win);
	int count = 0;
	SDL_DisplayMode **modes = SDL_GetFullscreenDisplayModes(displayID, &count);
	if (!modes) return false;
	
	bool found = false;
	for (int i = 0; i < count; i++) {
		if (modes[i]->w == width && modes[i]->h == height && (int)modes[i]->refresh_rate == framerate) {
			found = SDL_SetWindowFullscreenMode(win, modes[i]);
			break;
		}
	}
	SDL_free(modes);
	return found;
 }

HL_PRIM int HL_NAME(win_display_handle)(SDL_Window *win) {
	return (int)SDL_GetDisplayForWindow(win);
}

HL_PRIM void HL_NAME(win_set_title)(SDL_Window *win, vbyte *title) {
	SDL_SetWindowTitle(win, (char*)title);
}

HL_PRIM void HL_NAME(win_set_position)(SDL_Window *win, int x, int y) {
	SDL_SetWindowPosition(win, x, y);
}

HL_PRIM void HL_NAME(win_get_position)(SDL_Window *win, int *x, int *y) {
	SDL_GetWindowPosition(win, x, y);
}

HL_PRIM void HL_NAME(win_set_size)(SDL_Window *win, int width, int height) {
	SDL_SetWindowSize(win, width, height);
}

HL_PRIM void HL_NAME(win_set_min_size)(SDL_Window *win, int width, int height) {
	SDL_SetWindowMinimumSize(win, width, height);
}

HL_PRIM void HL_NAME(win_set_max_size)(SDL_Window *win, int width, int height) {
	SDL_SetWindowMaximumSize(win, width, height);
}

HL_PRIM void HL_NAME(win_get_size)(SDL_Window *win, int *width, int *height) {
	SDL_GetWindowSize(win, width, height);
}

HL_PRIM void HL_NAME(win_get_min_size)(SDL_Window *win, int *width, int *height) {
	SDL_GetWindowMinimumSize(win, width, height);
}

HL_PRIM void HL_NAME(win_get_max_size)(SDL_Window *win, int *width, int *height) {
	SDL_GetWindowMaximumSize(win, width, height);
}

HL_PRIM double HL_NAME(win_get_opacity)(SDL_Window *win) {
	float opacity = SDL_GetWindowOpacity(win);
	if (opacity < 0.0f) opacity = 1.0f;
	return opacity;
}

HL_PRIM bool HL_NAME(win_set_opacity)(SDL_Window *win, double opacity) {
	return SDL_SetWindowOpacity(win, (float)opacity);
}

HL_PRIM void HL_NAME(win_resize)(SDL_Window *win, int mode) {
	switch( mode ) {
	case 0:
		SDL_MaximizeWindow(win);
		break;
	case 1:
		SDL_MinimizeWindow(win);
		break;
	case 2:
		SDL_RestoreWindow(win);
		break;
	case 3:
		SDL_ShowWindow(win);
		break;
	case 4:
		SDL_HideWindow(win);
		break;
	default:
		break;
	}
}


HL_PRIM void HL_NAME(win_swap_window)(SDL_Window *win) {
	SDL_GL_SwapWindow(win);
}

HL_PRIM void HL_NAME(win_render_to)(SDL_Window *win, SDL_GLContext gl) {
	SDL_GL_MakeCurrent(win, gl);
}

HL_PRIM int HL_NAME(win_get_id)(SDL_Window *window) {
	return (int)SDL_GetWindowID(window);
}

HL_PRIM void HL_NAME(win_destroy)(SDL_Window *win, SDL_GLContext gl) {
	if (gl) SDL_GL_DestroyContext(gl);
	SDL_DestroyWindow(win);
}

#define TGL _ABSTRACT(sdl_gl)
DEFINE_PRIM(TWIN, win_create_ex, _I32 _I32 _I32 _I32 _I32);
DEFINE_PRIM(TWIN, win_create, _I32 _I32);
DEFINE_PRIM(TGL, win_get_glcontext, TWIN);
DEFINE_PRIM(_BOOL, win_set_fullscreen, TWIN _I32);
DEFINE_PRIM(_BOOL, win_set_display_mode, TWIN _I32 _I32 _I32);
DEFINE_PRIM(_I32, win_display_handle, TWIN);
DEFINE_PRIM(_VOID, win_resize, TWIN _I32);
DEFINE_PRIM(_VOID, win_set_title, TWIN _BYTES);
DEFINE_PRIM(_VOID, win_set_position, TWIN _I32 _I32);
DEFINE_PRIM(_VOID, win_get_position, TWIN _REF(_I32) _REF(_I32));
DEFINE_PRIM(_VOID, win_set_size, TWIN _I32 _I32);
DEFINE_PRIM(_VOID, win_set_min_size, TWIN _I32 _I32);
DEFINE_PRIM(_VOID, win_set_max_size, TWIN _I32 _I32);
DEFINE_PRIM(_VOID, win_get_size, TWIN _REF(_I32) _REF(_I32));
DEFINE_PRIM(_VOID, win_get_min_size, TWIN _REF(_I32) _REF(_I32));
DEFINE_PRIM(_VOID, win_get_max_size, TWIN _REF(_I32) _REF(_I32));
DEFINE_PRIM(_F64, win_get_opacity, TWIN);
DEFINE_PRIM(_BOOL, win_set_opacity, TWIN _F64);
DEFINE_PRIM(_VOID, win_swap_window, TWIN);
DEFINE_PRIM(_VOID, win_render_to, TWIN TGL);
DEFINE_PRIM(_VOID, win_destroy, TWIN TGL);
DEFINE_PRIM(_I32, win_get_id, TWIN);

// game controller (SDL3 uses SDL_Gamepad instead of SDL_GameController)

HL_PRIM int HL_NAME(gctrl_count)() {
	int count = 0;
	SDL_JoystickID *joysticks = SDL_GetJoysticks(&count);
	SDL_free(joysticks);
	return count;
}

HL_PRIM SDL_Gamepad *HL_NAME(gctrl_open)(int idx) {
	int count = 0;
	SDL_JoystickID *joysticks = SDL_GetJoysticks(&count);
	if (!joysticks || idx < 0 || idx >= count) {
		SDL_free(joysticks);
		return NULL;
	}
	SDL_JoystickID id = joysticks[idx];
	SDL_free(joysticks);
	if (SDL_IsGamepad(id))
		return SDL_OpenGamepad(id);
	return NULL;
}

HL_PRIM void HL_NAME(gctrl_close)(SDL_Gamepad *controller) {
	SDL_CloseGamepad(controller);
}

HL_PRIM int HL_NAME(gctrl_get_axis)(SDL_Gamepad *controller, int axisIdx ){
	Sint16 val = SDL_GetGamepadAxis(controller, axisIdx);
	return (int)val;
}

HL_PRIM bool HL_NAME(gctrl_get_button)(SDL_Gamepad *controller, int btnIdx) {
	return SDL_GetGamepadButton(controller, btnIdx);
}

HL_PRIM int HL_NAME(gctrl_get_id)(SDL_Gamepad *controller) {
	SDL_Joystick *joy = SDL_GetGamepadJoystick(controller);
	if (joy)
		return (int)SDL_GetJoystickID(joy);
	return 0;
}

HL_PRIM vbyte *HL_NAME(gctrl_get_name)(SDL_Gamepad *controller) {
	return (vbyte*)SDL_GetGamepadName(controller);
}

#define TGCTRL _ABSTRACT(sdl_gamepad)
DEFINE_PRIM(_I32, gctrl_count, _NO_ARG);
DEFINE_PRIM(TGCTRL, gctrl_open, _I32);
DEFINE_PRIM(_VOID, gctrl_close, TGCTRL);
DEFINE_PRIM(_I32, gctrl_get_axis, TGCTRL _I32);
DEFINE_PRIM(_BOOL, gctrl_get_button, TGCTRL _I32);
DEFINE_PRIM(_I32, gctrl_get_id, TGCTRL);
DEFINE_PRIM(_BYTES, gctrl_get_name, TGCTRL);

// haptic

HL_PRIM SDL_Haptic *HL_NAME(haptic_open)(SDL_Gamepad *controller) {
	SDL_Joystick *joy = SDL_GetGamepadJoystick(controller);
	if (joy)
		return SDL_OpenHapticFromJoystick(joy);
	return NULL;
}

HL_PRIM void HL_NAME(haptic_close)(SDL_Haptic *haptic) {
	SDL_CloseHaptic(haptic);
}

HL_PRIM int HL_NAME(haptic_rumble_init)(SDL_Haptic *haptic) {
	return SDL_InitHapticRumble(haptic) ? 0 : -1;
}

HL_PRIM int HL_NAME(haptic_rumble_play)(SDL_Haptic *haptic, double strength, int length) {
	return SDL_PlayHapticRumble(haptic, (float)strength, (Uint32)length) ? 0 : -1;
}
#define THAPTIC _ABSTRACT(sdl_haptic)
DEFINE_PRIM(THAPTIC, haptic_open, TGCTRL);
DEFINE_PRIM(_VOID, haptic_close, THAPTIC);
DEFINE_PRIM(_I32, haptic_rumble_init, THAPTIC);
DEFINE_PRIM(_I32, haptic_rumble_play, THAPTIC _F64 _I32);

// joystick

HL_PRIM int HL_NAME(joy_count)() {
	int count = 0;
	SDL_JoystickID *joysticks = SDL_GetJoysticks(&count);
	SDL_free(joysticks);
	return count;
}

HL_PRIM SDL_Joystick *HL_NAME(joy_open)(int idx) {
	int count = 0;
	SDL_JoystickID *joysticks = SDL_GetJoysticks(&count);
	if (!joysticks || idx < 0 || idx >= count) {
		SDL_free(joysticks);
		return NULL;
	}
	SDL_JoystickID id = joysticks[idx];
	SDL_free(joysticks);
	return SDL_OpenJoystick(id);
}

HL_PRIM void HL_NAME(joy_close)(SDL_Joystick *joystick) {
	SDL_CloseJoystick(joystick);
}

HL_PRIM int HL_NAME(joy_get_axis)(SDL_Joystick *joystick, int axisIdx ){
	return (int)SDL_GetJoystickAxis(joystick, axisIdx);
}

HL_PRIM bool HL_NAME(joy_get_button)(SDL_Joystick *joystick, int btnIdx) {
	return SDL_GetJoystickButton(joystick, btnIdx);
}

HL_PRIM int HL_NAME(joy_get_id)(SDL_Joystick *joystick) {
	return (int)SDL_GetJoystickID(joystick);
}

HL_PRIM vbyte *HL_NAME(joy_get_name)(SDL_Joystick *joystick) {
	return (vbyte*)SDL_GetJoystickName(joystick);
}

#define TJOY _ABSTRACT(sdl_joystick)
DEFINE_PRIM(_I32, joy_count, _NO_ARG);
DEFINE_PRIM(TJOY, joy_open, _I32);
DEFINE_PRIM(_VOID, joy_close, TJOY);
DEFINE_PRIM(_I32, joy_get_axis, TJOY _I32);
DEFINE_PRIM(_BOOL, joy_get_button, TJOY _I32);
DEFINE_PRIM(_I32, joy_get_id, TJOY);
DEFINE_PRIM(_BYTES, joy_get_name, TJOY);

// clipboard

HL_PRIM void HL_NAME(set_clipboard_text)(vbyte *text) {
	SDL_SetClipboardText((char*)text);
}

HL_PRIM vbyte *HL_NAME(get_clipboard_text)() {
	char *text = SDL_GetClipboardText();
	vbyte *result = (vbyte*)hl_copy_bytes(text, (int)strlen(text) + 1);
	SDL_free(text);
	return result;
}

DEFINE_PRIM(_VOID, set_clipboard_text, _BYTES);
DEFINE_PRIM(_BYTES, get_clipboard_text, _NO_ARG);

// cursor

HL_PRIM SDL_Cursor *HL_NAME(create_system_cursor)(int id) {
	return SDL_CreateSystemCursor(id);
}

HL_PRIM void HL_NAME(set_cursor)(SDL_Cursor *cursor) {
	SDL_SetCursor(cursor);
}

HL_PRIM void HL_NAME(destroy_cursor)(SDL_Cursor *cursor) {
	SDL_DestroyCursor(cursor);
}

HL_PRIM bool HL_NAME(show_cursor)(bool show) {
	return SDL_CursorVisible(show);
}

#define TCURSOR _ABSTRACT(sdl_cursor)
DEFINE_PRIM(TCURSOR, create_system_cursor, _I32);
DEFINE_PRIM(_VOID, set_cursor, TCURSOR);
DEFINE_PRIM(_VOID, destroy_cursor, TCURSOR);
DEFINE_PRIM(_BOOL, show_cursor, _BOOL);

// surface

HL_PRIM SDL_Surface *HL_NAME(load_bmp)(vbyte *path) {
	return SDL_LoadBMP((char*)path);
}

HL_PRIM void HL_NAME(free_surface)(SDL_Surface *surface) {
	SDL_DestroySurface(surface);
}

HL_PRIM int HL_NAME(get_surface_width)(SDL_Surface *surface) {
	return surface->w;
}

HL_PRIM int HL_NAME(get_surface_height)(SDL_Surface *surface) {
	return surface->h;
}

#define TSURFACE _ABSTRACT(sdl_surface)
DEFINE_PRIM(TSURFACE, load_bmp, _BYTES);
DEFINE_PRIM(_VOID, free_surface, TSURFACE);
DEFINE_PRIM(_I32, get_surface_width, TSURFACE);
DEFINE_PRIM(_I32, get_surface_height, TSURFACE);

// pixel format

HL_PRIM int HL_NAME(get_pixel_format_enum)(int bpp, Uint32 rmask, Uint32 gmask, Uint32 bmask, Uint32 amask) {
	return SDL_GetPixelFormatEnumForMasks(bpp, rmask, gmask, bmask, amask);
}

DEFINE_PRIM(_I32, get_pixel_format_enum, _I32 _I32 _I32 _I32 _I32);

// audio

static SDL_AudioDeviceID audio_devid = 0;

HL_PRIM bool HL_NAME(open_audio)(int freq, int channels, int samples) {
	SDL_AudioSpec spec;
	spec.freq = freq;
	spec.format = SDL_AUDIO_S16;
	spec.channels = channels;
	spec.samples = samples;
	
	audio_devid = SDL_OpenAudioDevice(SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK, &spec);
	if (audio_devid == 0) {
		return false;
	}
	// SDL3 opens devices in a paused state, so we need to resume
	SDL_ResumeAudioDevice(audio_devid);
	return true;
}

HL_PRIM void HL_NAME(close_audio)() {
	if (audio_devid != 0) {
		SDL_CloseAudioDevice(audio_devid);
		audio_devid = 0;
	}
}

HL_PRIM void HL_NAME(pause_audio)(bool pause) {
	if (audio_devid != 0) {
		if (pause)
			SDL_PauseAudioDevice(audio_devid);
		else
			SDL_ResumeAudioDevice(audio_devid);
	}
}

HL_PRIM void HL_NAME(queue_audio)(vbyte *data, int len) {
	if (audio_devid != 0) {
		SDL_SendQueueAudio(audio_devid, data, len);
	}
}

DEFINE_PRIM(_BOOL, open_audio, _I32 _I32 _I32);
DEFINE_PRIM(_VOID, close_audio, _NO_ARG);
DEFINE_PRIM(_VOID, pause_audio, _BOOL);
DEFINE_PRIM(_VOID, queue_audio, _BYTES _I32);

// sound channel

HL_PRIM int HL_NAME(mix_channels)(vbyte *dst, vbyte *src, int len, int volume) {
	SDL_MixAudio(dst, src, SDL_AUDIO_S16, len, volume);
	return len;
}

DEFINE_PRIM(_I32, mix_channels, _BYTES _BYTES _I32 _I32);
