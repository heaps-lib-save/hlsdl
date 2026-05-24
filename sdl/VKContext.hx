package sdl;

#if (hlsdl3 && heaps_vulkan)

private typedef NativeVKContext = hl.Abstract<"sdl_vk_context">;

class VKContext {
	var native : NativeVKContext;

	public var width(get,never) : Int;
	public var height(get,never) : Int;

	public function new(win : sdl.Window) {
		native = createContextImpl(@:privateAccess win.win, true);
		if (native == null) throw "Vulkan context creation failed";
	}

	public function isNull() return native == null;
	public function waitIdle() { waitIdle_native(native); }
	public function dispose() { if (native != null) { destroyContextImpl(native); native = null; } }

	public function initSwapchain(w:Int, h:Int) : Bool return initSwapchain_native(native, w, h);
	public function beginFrame() : Bool return beginFrame_native(native);
	public function endFrame() : Bool return endFrame_native(native);
	function get_width() : Int return getWidth_native(native);
	function get_height() : Int return getHeight_native(native);

	public function createRenderPass(hasDepth:Bool, depthFormat:Int) : VKRenderPass return cast createRenderPass_native(native, hasDepth, depthFormat);
	public function createFramebuffers(rp:VKRenderPass) : Bool return createFramebuffers_native(native, cast rp);
	public function createDescriptorPool() { createDescriptorPool_native(native); }
	public function createCommandPool() : Bool return createCommandPool_native(native);
	public function createCommandBuffers(count:Int) : Bool return createCommandBuffers_native(native, count);
	public function getCommandBuffer(idx:Int) : VKCommandBuffer return cast getCommandBuffer_native(native, idx);
	public function beginCommandBuffer(idx:Int) : Bool return beginCommandBuffer_native(native, idx);
	public function endCommandBuffer(idx:Int) : Bool return endCommandBuffer_native(native, idx);
	public function clearColorImage(r:Float,g:Float,b:Float,a:Float) { clearColorImage_native(native, r, g, b, a); }
	public function beginRenderPass() { beginRenderPass_native(native); }
	public function endRenderPass() { endRenderPass_native(native); }

	public function createBuffer(size:Int, usage:Int) : {buf:VKBuffer, mem:VKMemory} {
		var id = createBuffer_native(native, size, usage);
		return {buf: cast id, mem: cast id};
	}
	public function destroyBuffer(buf:VKBuffer, mem:VKMemory) { destroyBuffer_native(native, cast buf); }
	public function uploadBuffer(mem:VKMemory, data:hl.Bytes, offset:Int, size:Int) { uploadBuffer_native(native, cast mem, data, offset, size); }
	public function uploadBufferFloats(mem:VKMemory, arr:Dynamic, srcFloatOff:Int, dstByteOff:Int, floatCount:Int) { uploadBufferFloats_native(native, cast mem, arr, srcFloatOff, dstByteOff, floatCount); }
	public function uploadBufferShorts(mem:VKMemory, arr:Dynamic, srcShortOff:Int, dstByteOff:Int, shortCount:Int) { uploadBufferShorts_native(native, cast mem, arr, srcShortOff, dstByteOff, shortCount); }
	public function getBufferHandle(buf:VKBuffer) : Int return getBufferHandle_native(native, cast buf);

	public function createShader(code:hl.Bytes, byteSize:Int) : VKShader return cast createShader_native(native, code, byteSize);
	public function destroyShader(s:VKShader) { destroyShader_native(native, cast s); }

	public function createPipelineLayout(dslTexId:Int = -1, dslBufId:Int = -1, pcSize:Int = 0) : VKPipelineLayout return cast createPipelineLayout_native(native, dslTexId, dslBufId, pcSize);
	public function destroyPipelineLayout(pl:VKPipelineLayout) { destroyPipelineLayout_native(native, cast pl); }

	public function createGraphicsPipeline(vs:VKShader,fs:VKShader,layout:VKPipelineLayout,rp:VKRenderPass,vbCnt:Int,vb:hl.Bytes,vaCnt:Int,va:hl.Bytes,topo:Int,cull:Int,ff:Int,blend:Int,sblend:Int,dblend:Int,dt:Int,dw:Int,dc:Int,w:Int,h:Int,samples:Int = 1) : VKPipeline {
		return cast createGraphicsPipeline_native(native, cast vs, cast fs, cast layout, cast rp, topo, cull, ff, blend, sblend, dblend, dt, dw, dc, samples);
	}
	public function createGraphicsPipeline2D(vs:VKShader,fs:VKShader,layout:VKPipelineLayout,rp:VKRenderPass,vbCnt:Int,vb:hl.Bytes,vaCnt:Int,va:hl.Bytes,topo:Int,cull:Int,ff:Int,blend:Int,sblend:Int,dblend:Int,dt:Int,dw:Int,dc:Int,w:Int,h:Int,samples:Int = 1) : VKPipeline {
		return cast createGraphicsPipeline2D_native(native, cast vs, cast fs, cast layout, cast rp, topo, cull, ff, blend, sblend, dblend, dt, dw, dc, samples);
	}
	public function destroyPipeline(p:VKPipeline) { if (cast p != 0) destroyPipeline_native(native, cast p); }

	public function cmdBindPipeline(cb:Int, pipeline:VKPipeline) { cmdBindPipeline_native(native, cb, cast pipeline); }
	public function cmdBindVertexBuffer(cb:Int, binding:Int, buf:VKBuffer, offset:Int) { cmdBindVertexBuffer_native(native, cb, binding, cast buf, offset); }
	public function cmdBindIndexBuffer(cb:Int, buf:VKBuffer, offset:Int, idxType:Int) { cmdBindIndexBuffer_native(native, cb, cast buf, offset, idxType); }
	public function cmdSetViewport(cb:Int, x:Single, y:Single, w:Single, h:Single) { cmdSetViewport_native(native, cb, x, y, w, h); }
	public function cmdSetScissor(cb:Int, x:Int, y:Int, w:Int, h:Int) { cmdSetScissor_native(native, cb, x, y, w, h); }
	public function cmdDrawIndexed(cb:Int, idxCount:Int, instCount:Int, firstIdx:Int, vertOff:Int, firstInst:Int) { cmdDrawIndexed_native(native, cb, idxCount, instCount, firstIdx, vertOff, firstInst); }
	public function cmdDraw(cb:Int, vertCount:Int, instCount:Int, firstVert:Int, firstInst:Int) { cmdDraw_native(native, cb, vertCount, instCount, firstVert, firstInst); }

	public function cmdPushConstants(cb:Int, layout:VKPipelineLayout, stageFlags:Int, offset:Int, size:Int, data:hl.Bytes) {
		cmdPushConstants_native(native, cb, cast layout, stageFlags, offset, size, data);
	}

	public function createDescriptorSetLayout(bindingCount:Int, bindingType:Int = 0) : Int return createDescriptorSetLayout_native(native, bindingCount, bindingType);
	public function getDescriptorSetLayoutHandle(dslId:Int) : Int return getDescriptorSetLayoutHandle_native(native, dslId);
	public function allocateDescriptorSet(dslId:Int) : VKDescriptorSet return cast allocateDescriptorSet_native(native, dslId);
	public function updateDescriptorSetTexture(ds:VKDescriptorSet, binding:Int, sampler:VKSampler, view:VKImageView) {
		updateDescriptorSetTexture_native(native, cast ds, binding, cast sampler, cast view);
	}
	public function updateDescriptorSetBuffer(ds:VKDescriptorSet, binding:Int, buf:VKBuffer, offset:Int, range:Int) {
		updateDescriptorSetBuffer_native(native, cast ds, binding, cast buf, offset, range);
	}
	public function cmdBindDescriptorSets(cb:Int, ds:VKDescriptorSet, firstSet:Int, layout:VKPipelineLayout) {
		cmdBindDescriptorSets_native(native, cb, cast ds, firstSet, cast layout);
	}
	public function destroyDescriptorSetLayout(dslId:Int) { destroyDescriptorSetLayout_native(native, dslId); }

	public function cmdBlitImage(cb:Int, srcImg:VKImage, dstImg:VKImage, srcMip:Int, dstMip:Int) {
		cmdBlitImage_native(native, cb, cast srcImg, cast dstImg, srcMip, dstMip);
	}
	public function cmdCopyBufferToImage(cb:Int, srcBuf:VKBuffer, dstImg:VKImage, mipLevel:Int, arrayLayer:Int) {
		cmdCopyBufferToImage_native(native, cb, cast srcBuf, cast dstImg, mipLevel, arrayLayer);
	}

	public function createImage(w:Int,h:Int,fmt:Int,mips:Int,layers:Int,usage:Int) : {img:VKImage, mem:VKMemory} {
		var id = createImage_native(native, w, h, fmt, mips, layers, usage);
		return {img: cast id, mem: cast id};
	}
	public function createImageView(img:VKImage,fmt:Int,aspect:Int,bm:Int,mc:Int,bl:Int,lc:Int) : VKImageView {
		return cast createImageView_native(native, cast img, fmt, aspect, bm, mc, bl, lc);
	}
	public function createSampler(filter:Int, mipMode:Int, addrMode:Int, anisotropy:Bool = true, maxAnisotropy:Single = 16) : VKSampler {
		return cast createSampler_native(native, filter, mipMode, addrMode, anisotropy, maxAnisotropy);
	}
	public function destroyImage(img:VKImage, mem:VKMemory) { destroyImage_native(native, cast img, cast mem); }
	public function destroyImageView(v:VKImageView) { destroyImageView_native(native, cast v); }
	public function destroySampler(s:VKSampler) { destroySampler_native(native, cast s); }
	public function cmdSetDepthBias(cb:Int, cf:Single, clamp:Single, sf:Single) { cmdSetDepthBias_native(native, cb, cf, clamp, sf); }
	public function cmdPipelineBarrier(cb:Int, src:Int,dst:Int,sa:Int,da:Int,ol:Int,nl:Int,img:VKImage,aspect:Int,bm:Int,mc:Int,bl:Int,lc:Int) {
		cmdPipelineBarrier_native(native, cb, src, dst, sa, da, ol, nl, cast img, aspect, bm, mc, bl, lc);
	}

	public function getImageHandle(img:VKImage) : Int return getImageHandle_native(native, cast img);
	public function getImageWidth(img:VKImage) : Int return getImageWidth_native(native, cast img);
	public function getImageHeight(img:VKImage) : Int return getImageHeight_native(native, cast img);
	public function uploadTextureData(img:Int, data:hl.Bytes, offset:Int, size:Int, mipLevel:Int, side:Int) : Bool return uploadTextureData_native(native, img, data, offset, size, mipLevel, side);

	@:hlNative("sdl_vk", "create_context") static function createContextImpl(win:hl.Abstract<"sdl_window">, debug:Bool):NativeVKContext return null;
	@:hlNative("sdl_vk", "destroy_context") static function destroyContextImpl(ctx:NativeVKContext) {}
	@:hlNative("sdl_vk", "wait_idle") static function waitIdle_native(ctx:NativeVKContext) {}

	@:hlNative("sdl_vk", "init_swapchain") static function initSwapchain_native(ctx:NativeVKContext, w:Int, h:Int):Bool return false;
	@:hlNative("sdl_vk", "begin_frame") static function beginFrame_native(ctx:NativeVKContext):Bool return false;
	@:hlNative("sdl_vk", "end_frame") static function endFrame_native(ctx:NativeVKContext):Bool return false;
	@:hlNative("sdl_vk", "get_width") static function getWidth_native(ctx:NativeVKContext):Int return 0;
	@:hlNative("sdl_vk", "get_height") static function getHeight_native(ctx:NativeVKContext):Int return 0;

	@:hlNative("sdl_vk", "create_render_pass") static function createRenderPass_native(ctx:NativeVKContext, hasDepth:Bool, df:Int):VKRenderPass return cast 0;
	@:hlNative("sdl_vk", "create_framebuffers") static function createFramebuffers_native(ctx:NativeVKContext, rp:VKRenderPass):Bool return false;
	@:hlNative("sdl_vk", "create_descriptor_pool") static function createDescriptorPool_native(ctx:NativeVKContext) {}
	@:hlNative("sdl_vk", "create_command_pool") static function createCommandPool_native(ctx:NativeVKContext):Bool return false;
	@:hlNative("sdl_vk", "create_command_buffers") static function createCommandBuffers_native(ctx:NativeVKContext, count:Int):Bool return false;
	@:hlNative("sdl_vk", "get_command_buffer") static function getCommandBuffer_native(ctx:NativeVKContext, idx:Int):VKCommandBuffer return cast 0;
	@:hlNative("sdl_vk", "begin_command_buffer") static function beginCommandBuffer_native(ctx:NativeVKContext, idx:Int):Bool return false;
	@:hlNative("sdl_vk", "end_command_buffer") static function endCommandBuffer_native(ctx:NativeVKContext, idx:Int):Bool return false;
	@:hlNative("sdl_vk", "clear_color_image") static function clearColorImage_native(ctx:NativeVKContext, r:Float,g:Float,b:Float,a:Float) {}
	@:hlNative("sdl_vk", "begin_render_pass") static function beginRenderPass_native(ctx:NativeVKContext) {}
	@:hlNative("sdl_vk", "end_render_pass") static function endRenderPass_native(ctx:NativeVKContext) {}

	@:hlNative("sdl_vk", "create_buffer") static function createBuffer_native(ctx:NativeVKContext, size:Int, usage:Int):Int return -1;
	@:hlNative("sdl_vk", "destroy_buffer") static function destroyBuffer_native(ctx:NativeVKContext, id:Int) {}
	@:hlNative("sdl_vk", "upload_buffer") static function uploadBuffer_native(ctx:NativeVKContext, id:Int, data:hl.Bytes, offset:Int, size:Int) {}
	@:hlNative("sdl_vk", "upload_buffer_floats") static function uploadBufferFloats_native(ctx:NativeVKContext, id:Int, arr:Dynamic, srcFloatOff:Int, dstByteOff:Int, floatCount:Int) {}
	@:hlNative("sdl_vk", "upload_buffer_shorts") static function uploadBufferShorts_native(ctx:NativeVKContext, id:Int, arr:Dynamic, srcShortOff:Int, dstByteOff:Int, shortCount:Int) {}
	@:hlNative("sdl_vk", "get_buffer_handle") static function getBufferHandle_native(ctx:NativeVKContext, id:Int):Int return 0;

	@:hlNative("sdl_vk", "create_shader") static function createShader_native(ctx:NativeVKContext, code:hl.Bytes, size:Int):Int return 0;
	@:hlNative("sdl_vk", "destroy_shader") static function destroyShader_native(ctx:NativeVKContext, s:Int) {}

	@:hlNative("sdl_vk", "create_pipeline_layout") static function createPipelineLayout_native(ctx:NativeVKContext, dslTexId:Int, dslBufId:Int, pcSize:Int):Int return 0;
	@:hlNative("sdl_vk", "destroy_pipeline_layout") static function destroyPipelineLayout_native(ctx:NativeVKContext, pl:Int) {}

	@:hlNative("sdl_vk", "create_graphics_pipeline") static function createGraphicsPipeline_native(ctx:NativeVKContext, vs:Int,fs:Int,layout:Int,rp:Int,topo:Int,cull:Int,ff:Int,blend:Int,sblend:Int,dblend:Int,dt:Int,dw:Int,dc:Int,samples:Int):Int return 0;
	@:hlNative("sdl_vk", "create_graphics_pipeline_2d") static function createGraphicsPipeline2D_native(ctx:NativeVKContext, vs:Int,fs:Int,layout:Int,rp:Int,topo:Int,cull:Int,ff:Int,blend:Int,sblend:Int,dblend:Int,dt:Int,dw:Int,dc:Int,samples:Int):Int return 0;
	@:hlNative("sdl_vk", "destroy_pipeline") static function destroyPipeline_native(ctx:NativeVKContext, p:Int) {}

	@:hlNative("sdl_vk", "cmd_bind_pipeline") static function cmdBindPipeline_native(ctx:NativeVKContext, cb:Int, pipe:Int) {}
	@:hlNative("sdl_vk", "cmd_bind_vertex_buffer") static function cmdBindVertexBuffer_native(ctx:NativeVKContext, cb:Int, binding:Int, bid:Int, offset:Int) {}
	@:hlNative("sdl_vk", "cmd_bind_index_buffer") static function cmdBindIndexBuffer_native(ctx:NativeVKContext, cb:Int, bid:Int, offset:Int, idxType:Int) {}
	@:hlNative("sdl_vk", "cmd_set_viewport") static function cmdSetViewport_native(ctx:NativeVKContext, cb:Int, x:Single, y:Single, w:Single, h:Single) {}
	@:hlNative("sdl_vk", "cmd_set_scissor") static function cmdSetScissor_native(ctx:NativeVKContext, cb:Int, x:Int, y:Int, w:Int, h:Int) {}
	@:hlNative("sdl_vk", "cmd_draw") static function cmdDraw_native(ctx:NativeVKContext, cb:Int, vc:Int, ic:Int, fv:Int, fi:Int) {}
	@:hlNative("sdl_vk", "cmd_draw_indexed") static function cmdDrawIndexed_native(ctx:NativeVKContext, cb:Int, idxCount:Int, instCount:Int, firstIdx:Int, vertOff:Int, firstInst:Int) {}

	@:hlNative("sdl_vk", "cmd_push_constants") static function cmdPushConstants_native(ctx:NativeVKContext, cb:Int, layout:Int, stageFlags:Int, offset:Int, size:Int, data:hl.Bytes) {}
	@:hlNative("sdl_vk", "create_descriptor_set_layout") static function createDescriptorSetLayout_native(ctx:NativeVKContext, bindingCount:Int, bindingType:Int):Int return -1;
	@:hlNative("sdl_vk", "get_descriptor_set_layout_handle") static function getDescriptorSetLayoutHandle_native(ctx:NativeVKContext, dslId:Int):Int return 0;
	@:hlNative("sdl_vk", "allocate_descriptor_set") static function allocateDescriptorSet_native(ctx:NativeVKContext, dslId:Int):Int return 0;
	@:hlNative("sdl_vk", "update_descriptor_set_texture") static function updateDescriptorSetTexture_native(ctx:NativeVKContext, ds:Int, binding:Int, sampler:Int, view:Int) {}
	@:hlNative("sdl_vk", "update_descriptor_set_buffer") static function updateDescriptorSetBuffer_native(ctx:NativeVKContext, ds:Int, binding:Int, buf:Int, offset:Int, range:Int) {}
	@:hlNative("sdl_vk", "cmd_bind_descriptor_sets") static function cmdBindDescriptorSets_native(ctx:NativeVKContext, cb:Int, ds:Int, firstSet:Int, layout:Int) {}
	@:hlNative("sdl_vk", "destroy_descriptor_set_layout") static function destroyDescriptorSetLayout_native(ctx:NativeVKContext, dslId:Int) {}
	@:hlNative("sdl_vk", "cmd_blit_image") static function cmdBlitImage_native(ctx:NativeVKContext, cb:Int, srcId:Int, dstId:Int, srcMip:Int, dstMip:Int) {}
	@:hlNative("sdl_vk", "cmd_copy_buffer_to_image") static function cmdCopyBufferToImage_native(ctx:NativeVKContext, cb:Int, bufId:Int, imgId:Int, mipLevel:Int, arrayLayer:Int) {}

	@:hlNative("sdl_vk", "create_image") static function createImage_native(ctx:NativeVKContext, w:Int,h:Int,fmt:Int,mips:Int,layers:Int,usage:Int):Int return -1;
	@:hlNative("sdl_vk", "create_image_view") static function createImageView_native(ctx:NativeVKContext, imgId:Int,fmt:Int,aspect:Int,bm:Int,mc:Int,bl:Int,lc:Int):Int return 0;
	@:hlNative("sdl_vk", "create_sampler") static function createSampler_native(ctx:NativeVKContext, filter:Int,mipMode:Int,addrMode:Int,anisotropy:Bool,maxAnisotropy:Single):Int return 0;
	@:hlNative("sdl_vk", "destroy_image") static function destroyImage_native(ctx:NativeVKContext, imgId:Int,memId:Int) {}
	@:hlNative("sdl_vk", "destroy_image_view") static function destroyImageView_native(ctx:NativeVKContext, view:Int) {}
	@:hlNative("sdl_vk", "destroy_sampler") static function destroySampler_native(ctx:NativeVKContext, sampler:Int) {}
	@:hlNative("sdl_vk", "cmd_pipeline_barrier") static function cmdPipelineBarrier_native(ctx:NativeVKContext, cb:Int,srcStage:Int,dstStage:Int,srcAccess:Int,dstAccess:Int,oldLayout:Int,newLayout:Int,img:Int,aspect:Int,bm:Int,mc:Int,bl:Int,lc:Int) {}
	@:hlNative("sdl_vk", "cmd_set_depth_bias") static function cmdSetDepthBias_native(ctx:NativeVKContext, cb:Int, cf:Single, clamp:Single, sf:Single) {}
	@:hlNative("sdl_vk", "get_image_handle") static function getImageHandle_native(ctx:NativeVKContext, imgId:Int):Int return 0;
	@:hlNative("sdl_vk", "get_image_width") static function getImageWidth_native(ctx:NativeVKContext, imgId:Int):Int return 0;
	@:hlNative("sdl_vk", "get_image_height") static function getImageHeight_native(ctx:NativeVKContext, imgId:Int):Int return 0;
	@:hlNative("sdl_vk", "upload_texture_data") static function uploadTextureData_native(ctx:NativeVKContext, imgId:Int, data:hl.Bytes, offset:Int, size:Int, mipLevel:Int, side:Int):Bool return false;
}

#end
