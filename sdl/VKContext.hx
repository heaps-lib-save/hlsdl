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

	public function createRenderPass(hasDepth:Bool, depthFormat:Int, colorAttachmentCount:Int = 1, samples:Int = 1) : VKRenderPass return cast createRenderPass_native(native, hasDepth, depthFormat, colorAttachmentCount, samples);
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
	public function beginRendering() { beginRendering_native(native); }
	public function endRendering() { endRendering_native(native); }
	public function hasDynamicRendering() : Bool return hasDynamicRendering_native(native);
	public function hasPushDescriptor() : Bool return hasPushDescriptor_native(native);
	public function hasExtendedDynamicStates() : Bool return hasExtendedDynamicStates_native(native);
	public function cmdPushDescriptorSetTexture(cb:Int, layout:VKPipelineLayout, set:Int, binding:Int, sampler:VKSampler, view:VKImageView) {
		cmdPushDescriptorSetTexture_native(native, cb, cast layout, set, binding, cast sampler, cast view);
	}
	public function cmdPushDescriptorSetBuffer(cb:Int, layout:VKPipelineLayout, set:Int, binding:Int, buf:VKBuffer, offset:Int, range:Int) {
		cmdPushDescriptorSetBuffer_native(native, cb, cast layout, set, binding, cast buf, offset, range);
	}

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

	public function createGraphicsPipeline(vs:VKShader,fs:VKShader,layout:VKPipelineLayout,rp:VKRenderPass,vbCnt:Int,vb:hl.Bytes,vaCnt:Int,va:hl.Bytes,topo:Int,cull:Int,ff:Int,blend:Int,sblend:Int,dblend:Int,dt:Int,dw:Int,dc:Int,w:Int,h:Int,samples:Int = 1, stencilFail:Int = 0, stencilPass:Int = 0, stencilDepthFail:Int = 0, stencilCompare:Int = 0, stencilRef:Int = 0, colorAttachmentCount:Int = 1) : VKPipeline {
		return cast createGraphicsPipeline_native(native, cast vs, cast fs, cast layout, cast rp, topo, cull, ff, blend, sblend, dblend, dt, dw, dc, samples, stencilFail, stencilPass, stencilDepthFail, stencilCompare, stencilRef, colorAttachmentCount);
	}
	public function createGraphicsPipeline2D(vs:VKShader,fs:VKShader,layout:VKPipelineLayout,rp:VKRenderPass,vbCnt:Int,vb:hl.Bytes,vaCnt:Int,va:hl.Bytes,topo:Int,cull:Int,ff:Int,blend:Int,sblend:Int,dblend:Int,dt:Int,dw:Int,dc:Int,w:Int,h:Int,samples:Int = 1, stencilFail:Int = 0, stencilPass:Int = 0, stencilDepthFail:Int = 0, stencilCompare:Int = 0, stencilRef:Int = 0, colorAttachmentCount:Int = 1) : VKPipeline {
		return cast createGraphicsPipeline2D_native(native, cast vs, cast fs, cast layout, cast rp, topo, cull, ff, blend, sblend, dblend, dt, dw, dc, samples, stencilFail, stencilPass, stencilDepthFail, stencilCompare, stencilRef, colorAttachmentCount);
	}
	public function createGraphicsPipelineDynamic(vs:VKShader,fs:VKShader,layout:VKPipelineLayout,rp:VKRenderPass,vbCnt:Int,vb:hl.Bytes,vaCnt:Int,va:hl.Bytes,topo:Int,cull:Int,ff:Int,blend:Int,sblend:Int,dblend:Int,dt:Int,dw:Int,dc:Int,w:Int,h:Int,samples:Int = 1, stencilFail:Int = 0, stencilPass:Int = 0, stencilDepthFail:Int = 0, stencilCompare:Int = 0, stencilRef:Int = 0, colorAttachmentCount:Int = 1) : VKPipeline {
		return cast createGraphicsPipelineDynamic_native(native, cast vs, cast fs, cast layout, cast rp, topo, cull, ff, blend, sblend, dblend, dt, dw, dc, samples, stencilFail, stencilPass, stencilDepthFail, stencilCompare, stencilRef, colorAttachmentCount);
	}
	public function destroyPipeline(p:VKPipeline) { if (cast p != 0) destroyPipeline_native(native, cast p); }

	public function cmdBindPipeline(cb:Int, pipeline:VKPipeline) { cmdBindPipeline_native(native, cb, cast pipeline); }
	public function cmdBindVertexBuffer(cb:Int, binding:Int, buf:VKBuffer, offset:Int) { cmdBindVertexBuffer_native(native, cb, binding, cast buf, offset); }
	public function cmdBindIndexBuffer(cb:Int, buf:VKBuffer, offset:Int, idxType:Int) { cmdBindIndexBuffer_native(native, cb, cast buf, offset, idxType); }
	public function cmdSetViewport(cb:Int, x:Single, y:Single, w:Single, h:Single) { cmdSetViewport_native(native, cb, x, y, w, h); }
	public function cmdSetScissor(cb:Int, x:Int, y:Int, w:Int, h:Int) { cmdSetScissor_native(native, cb, x, y, w, h); }
	public function cmdSetLineWidth(cb:Int, lineWidth:Single) { cmdSetLineWidth_native(native, cb, lineWidth); }
	public function cmdSetStencilReference(cb:Int, faceMask:Int, reference:Int) { cmdSetStencilReference_native(native, cb, faceMask, reference); }
	public function cmdSetCullMode(cb:Int, cullMode:Int) { cmdSetCullMode_native(native, cb, cullMode); }
	public function cmdSetFrontFace(cb:Int, frontFace:Int) { cmdSetFrontFace_native(native, cb, frontFace); }
	public function cmdSetPrimitiveTopology(cb:Int, topo:Int) { cmdSetPrimitiveTopology_native(native, cb, topo); }
	public function cmdSetDepthTestEnable(cb:Int, enable:Bool) { cmdSetDepthTestEnable_native(native, cb, enable); }
	public function cmdSetDepthWriteEnable(cb:Int, enable:Bool) { cmdSetDepthWriteEnable_native(native, cb, enable); }
	public function cmdSetDepthCompareOp(cb:Int, compareOp:Int) { cmdSetDepthCompareOp_native(native, cb, compareOp); }
	public function cmdSetStencilTestEnable(cb:Int, enable:Bool) { cmdSetStencilTestEnable_native(native, cb, enable); }
	public function cmdSetDepthBiasEnable(cb:Int, enable:Bool) { cmdSetDepthBiasEnable_native(native, cb, enable); }
	public function cmdSetRasterizerDiscardEnable(cb:Int, enable:Bool) { cmdSetRasterizerDiscardEnable_native(native, cb, enable); }
	public function checkDescriptorSetLayoutSupport(bindingCount:Int, bindingType:Int) : Bool return checkDescriptorSetLayoutSupport_native(native, bindingCount, bindingType);
	public function hostResetQueryPool(qpId:Int, firstQuery:Int, queryCount:Int) { hostResetQueryPool_native(native, qpId, firstQuery, queryCount); }
	public function cmdPushConstants2(cb:Int, layout:VKPipelineLayout, stageFlags:Int, offset:Int, size:Int, data:hl.Bytes) { cmdPushConstants2_native(native, cb, cast layout, stageFlags, offset, size, data); }
	public function cmdCopyImage(cb:Int, src:VKImage, dst:VKImage, srcLayout:Int, dstLayout:Int) { cmdCopyImage_native(native, cb, cast src, cast dst, srcLayout, dstLayout); }
	public function cmdCopyImageToBuffer(cb:Int, img:VKImage, layout:Int, buf:VKBuffer) { cmdCopyImageToBuffer_native(native, cb, cast img, layout, cast buf); }
	public function cmdClearDepthStencil(cb:Int, img:VKImage, layout:Int, depth:Single, stencil:Int, aspects:Int) { cmdClearDepthStencil_native(native, cb, cast img, layout, depth, stencil, aspects); }
	public function cmdSetBlendConstants(cb:Int, r:Single, g:Single, b:Single, a:Single) { cmdSetBlendConstants_native(native, cb, r, g, b, a); }
	public function createEvent() : Int return createEvent_native(native);
	public function destroyEvent(evtId:Int) { destroyEvent_native(native, evtId); }
	public function cmdSetEvent(cb:Int, evtId:Int, stage:Int) { cmdSetEvent_native(native, cb, evtId, stage); }
	public function cmdWaitEvents(cb:Int, evtId:Int, srcStage:Int, dstStage:Int) { cmdWaitEvents_native(native, cb, evtId, srcStage, dstStage); }
	public function flushMemory(buf:VKBuffer) { flushMemory_native(native, cast buf); }
	public function invalidateMemory(buf:VKBuffer) { invalidateMemory_native(native, cast buf); }
	public function bindImageMemory2(img:VKImage, mem:VKMemory) { bindImageMemory2_native(native, cast img, cast mem); }
	public function cmdSetPolygonMode(cb:Int, mode:Int) { cmdSetPolygonMode_native(native, cb, mode); }
	public function cmdSetPrimitiveRestartEnable(cb:Int, enable:Bool) { cmdSetPrimitiveRestartEnable_native(native, cb, enable); }
	public function cmdSetRasterizationSamples(cb:Int, samples:Int) { cmdSetRasterizationSamples_native(native, cb, samples); }
	public function cmdDrawIndirectByteCount(cb:Int, buf:VKBuffer, offset:Int, countBuf:VKBuffer, countOffset:Int, maxDrawCount:Int, stride:Int) { cmdDrawIndirectByteCount_native(native, cb, cast buf, offset, cast countBuf, countOffset, maxDrawCount, stride); }
	public function cmdSetLogicOpEnable(cb:Int, enable:Bool) { cmdSetLogicOpEnable_native(native, cb, enable); }
	public function cmdSetLogicOp(cb:Int, op:Int) { cmdSetLogicOp_native(native, cb, op); }
	public function cmdSetColorBlendEnable(cb:Int, firstAtt:Int, count:Int, enable:Bool) { cmdSetColorBlendEnable_native(native, cb, firstAtt, count, enable); }
	public function cmdSetColorBlendEquation(cb:Int, firstAtt:Int, count:Int, mode:Int, src:Int, dst:Int, alphaMode:Int, alphaSrc:Int, alphaDst:Int) { cmdSetColorBlendEquation_native(native, cb, firstAtt, count, mode, src, dst, alphaMode, alphaSrc, alphaDst); }
	public function cmdSetColorWriteMask(cb:Int, firstAtt:Int, count:Int, mask:Int) { cmdSetColorWriteMask_native(native, cb, firstAtt, count, mask); }
	public function cmdSetDepthClampEnable(cb:Int, enable:Bool) { cmdSetDepthClampEnable_native(native, cb, enable); }
	public function cmdSetProvokingVertexMode(cb:Int, mode:Int) { cmdSetProvokingVertexMode_native(native, cb, mode); }
	public function cmdSetLineRasterizationMode(cb:Int, mode:Int) { cmdSetLineRasterizationMode_native(native, cb, mode); }
	public function cmdSetTessellationDomainOrigin(cb:Int, origin:Int) { cmdSetTessellationDomainOrigin_native(native, cb, origin); }
	public function cmdCopyBuffer2(cb:Int, src:VKBuffer, dst:VKBuffer, size:Int) { cmdCopyBuffer2_native(native, cb, cast src, cast dst, size); }
	public function cmdCopyImage2(cb:Int, src:VKImage, dst:VKImage, srcLayout:Int, dstLayout:Int) { cmdCopyImage2_native(native, cb, cast src, cast dst, srcLayout, dstLayout); }
	public function cmdBlitImage2(cb:Int, src:VKImage, dst:VKImage, srcMip:Int, dstMip:Int) { cmdBlitImage2_native(native, cb, cast src, cast dst, srcMip, dstMip); }
	public function setDebugName(handle:Int, objType:Int, name:hl.Bytes) { setDebugName_native(native, handle, objType, name); }
	public function cmdBeginDebugLabel(cb:Int, r:Single, g:Single, b:Single, a:Single, name:hl.Bytes) { cmdBeginDebugLabel_native(native, cb, r, g, b, a, name); }
	public function cmdEndDebugLabel(cb:Int) { cmdEndDebugLabel_native(native, cb); }
	public function cmdResetEvent(cb:Int, evtId:Int, stage:Int) { cmdResetEvent_native(native, cb, evtId, stage); }
	public function getEventStatus(evtId:Int) : Bool return getEventStatus_native(native, evtId);
	public function cmdBeginConditionalRendering(cb:Int, buf:VKBuffer, offset:Int, inverted:Bool) { cmdBeginConditionalRendering_native(native, cb, cast buf, offset, inverted); }
	public function cmdEndConditionalRendering(cb:Int) { cmdEndConditionalRendering_native(native, cb); }
	public function cmdSetAlphaToOneEnable(cb:Int, enable:Bool) { cmdSetAlphaToOneEnable_native(native, cb, enable); }
	public function cmdSetFragmentShadingRate(cb:Int, sizeW:Int, sizeH:Int) { cmdSetFragmentShadingRate_native(native, cb, sizeW, sizeH); }
	public function cmdSetSampleLocations(cb:Int, samples:Int) { cmdSetSampleLocations_native(native, cb, samples); }
	public function createDescriptorUpdateTemplate(dslId:Int, pipelineLayout:VKPipelineLayout, set:Int, bindingCount:Int) : Int return createDescriptorUpdateTemplate_native(native, dslId, cast pipelineLayout, set, bindingCount);
	public function destroyDescriptorUpdateTemplate(id:Int) { destroyDescriptorUpdateTemplate_native(native, id); }
	public function cmdDrawIndexed(cb:Int, idxCount:Int, instCount:Int, firstIdx:Int, vertOff:Int, firstInst:Int) { cmdDrawIndexed_native(native, cb, idxCount, instCount, firstIdx, vertOff, firstInst); }
	public function cmdDraw(cb:Int, vertCount:Int, instCount:Int, firstVert:Int, firstInst:Int) { cmdDraw_native(native, cb, vertCount, instCount, firstVert, firstInst); }

	public function cmdDrawIndexedIndirect(cb:Int, buf:VKBuffer, offset:Int, drawCount:Int, stride:Int) { cmdDrawIndexedIndirect_native(native, cb, cast buf, offset, drawCount, stride); }
	public function cmdDrawIndirectCount(cb:Int, buf:VKBuffer, offset:Int, countBuf:VKBuffer, countOffset:Int, maxDrawCount:Int, stride:Int) { cmdDrawIndirectCount_native(native, cb, cast buf, offset, cast countBuf, countOffset, maxDrawCount, stride); }

	public function createQueryPool(queryType:Int, queryCount:Int) : Int return createQueryPool_native(native, queryType, queryCount);
	public function destroyQueryPool(qpId:Int) { destroyQueryPool_native(native, qpId); }
	public function cmdBeginQuery(cb:Int, qpId:Int, queryIdx:Int, flags:Int) { cmdBeginQuery_native(native, cb, qpId, queryIdx, flags); }
	public function cmdEndQuery(cb:Int, qpId:Int, queryIdx:Int) { cmdEndQuery_native(native, cb, qpId, queryIdx); }
	public function cmdResetQueryPool(cb:Int, qpId:Int, firstQuery:Int, queryCount:Int) { cmdResetQueryPool_native(native, cb, qpId, firstQuery, queryCount); }
	public function getQueryPoolResults(qpId:Int, firstQuery:Int, queryCount:Int, data:hl.Bytes, dataSize:Int, stride:Int, flags:Int) : Bool return getQueryPoolResults_native(native, qpId, firstQuery, queryCount, data, dataSize, stride, flags);
	public function cmdWriteTimestamp(cb:Int, qpId:Int, queryIdx:Int, stage:Int) { cmdWriteTimestamp_native(native, cb, qpId, queryIdx, stage); }

	public function cmdCopyBuffer(cb:Int, srcBuf:VKBuffer, dstBuf:VKBuffer, size:Int) { cmdCopyBuffer_native(native, cb, cast srcBuf, cast dstBuf, size); }
	public function cmdFillBuffer(cb:Int, buf:VKBuffer, dstOffset:Int, size:Int, data:Int) { cmdFillBuffer_native(native, cb, cast buf, dstOffset, size, data); }
	public function cmdUpdateBuffer(cb:Int, buf:VKBuffer, offset:Int, data:hl.Bytes, size:Int) { cmdUpdateBuffer_native(native, cb, cast buf, offset, data, size); }
	public function cmdClearAttachments(cb:Int, attachmentCount:Int, r:Single, g:Single, b:Single, a:Single) { cmdClearAttachments_native(native, cb, attachmentCount, r, g, b, a); }
	public function getBufferDeviceAddress(buf:VKBuffer) : hl.I64 return getBufferDeviceAddress_native(native, cast buf);

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

	public function createComputePipeline(cs:VKShader, layout:VKPipelineLayout) : VKPipeline return cast createComputePipeline_native(native, cast cs, cast layout);
	public function cmdBindComputePipeline(cb:Int, pipeline:VKPipeline) { cmdBindComputePipeline_native(native, cb, cast pipeline); }
	public function cmdBindComputeDescriptorSets(cb:Int, ds:VKDescriptorSet, firstSet:Int, layout:VKPipelineLayout) { cmdBindComputeDescriptorSets_native(native, cb, cast ds, firstSet, cast layout); }
	public function cmdDispatch(cb:Int, groupCountX:Int, groupCountY:Int, groupCountZ:Int) { cmdDispatchCompute_native(native, cb, groupCountX, groupCountY, groupCountZ); }

	public function cmdBlitImage(cb:Int, srcImg:VKImage, dstImg:VKImage, srcMip:Int, dstMip:Int) {
		cmdBlitImage_native(native, cb, cast srcImg, cast dstImg, srcMip, dstMip);
	}
	public function cmdResolveImage(cb:Int, srcImg:VKImage, dstImg:VKImage, srcMip:Int, dstMip:Int, srcLayer:Int, dstLayer:Int) {
		cmdResolveImage_native(native, cb, cast srcImg, cast dstImg, srcMip, dstMip, srcLayer, dstLayer);
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

	@:hlNative("sdl_vk", "create_render_pass") static function createRenderPass_native(ctx:NativeVKContext, hasDepth:Bool, df:Int, colorAttachmentCount:Int, samples:Int):VKRenderPass return cast 0;
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
	@:hlNative("sdl_vk", "begin_rendering") static function beginRendering_native(ctx:NativeVKContext) {}
	@:hlNative("sdl_vk", "end_rendering") static function endRendering_native(ctx:NativeVKContext) {}
	@:hlNative("sdl_vk", "has_dynamic_rendering") static function hasDynamicRendering_native(ctx:NativeVKContext):Bool return false;
	@:hlNative("sdl_vk", "has_push_descriptor") static function hasPushDescriptor_native(ctx:NativeVKContext):Bool return false;
	@:hlNative("sdl_vk", "has_extended_dynamic_states") static function hasExtendedDynamicStates_native(ctx:NativeVKContext):Bool return false;
	@:hlNative("sdl_vk", "compile_glsl_to_spv") public static function compileGLSLToSPV_native(glsl:hl.Bytes, isFrag:Bool, outPath:hl.Bytes):Int return 0;

	public function compileGLSLToSPV(glsl:haxe.io.Bytes, isFrag:Bool, outPath:String):Bool {
		return compileGLSLToSPV_native((glsl:hl.Bytes), isFrag, (haxe.io.Bytes.ofString(outPath):hl.Bytes)) > 0;
	}

	@:hlNative("sdl_vk", "cmd_push_descriptor_set_texture") static function cmdPushDescriptorSetTexture_native(ctx:NativeVKContext, cb:Int, layout:Int, set:Int, binding:Int, sampler:Int, view:Int) {}
	@:hlNative("sdl_vk", "cmd_push_descriptor_set_buffer") static function cmdPushDescriptorSetBuffer_native(ctx:NativeVKContext, cb:Int, layout:Int, set:Int, binding:Int, buf:Int, offset:Int, range:Int) {}

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

	@:hlNative("sdl_vk", "create_graphics_pipeline") static function createGraphicsPipeline_native(ctx:NativeVKContext, vs:Int,fs:Int,layout:Int,rp:Int,topo:Int,cull:Int,ff:Int,blend:Int,sblend:Int,dblend:Int,dt:Int,dw:Int,dc:Int,samples:Int,stencilFail:Int,stencilPass:Int,stencilDepthFail:Int,stencilCompare:Int,stencilRef:Int,colorAttachmentCount:Int):Int return 0;
	@:hlNative("sdl_vk", "create_graphics_pipeline_dynamic") static function createGraphicsPipelineDynamic_native(ctx:NativeVKContext, vs:Int,fs:Int,layout:Int,rp:Int,topo:Int,cull:Int,ff:Int,blend:Int,sblend:Int,dblend:Int,dt:Int,dw:Int,dc:Int,samples:Int,stencilFail:Int,stencilPass:Int,stencilDepthFail:Int,stencilCompare:Int,stencilRef:Int,colorAttachmentCount:Int):Int return 0;
	@:hlNative("sdl_vk", "create_graphics_pipeline_2d") static function createGraphicsPipeline2D_native(ctx:NativeVKContext, vs:Int,fs:Int,layout:Int,rp:Int,topo:Int,cull:Int,ff:Int,blend:Int,sblend:Int,dblend:Int,dt:Int,dw:Int,dc:Int,samples:Int,stencilFail:Int,stencilPass:Int,stencilDepthFail:Int,stencilCompare:Int,stencilRef:Int,colorAttachmentCount:Int):Int return 0;
	@:hlNative("sdl_vk", "destroy_pipeline") static function destroyPipeline_native(ctx:NativeVKContext, p:Int) {}

	@:hlNative("sdl_vk", "cmd_bind_pipeline") static function cmdBindPipeline_native(ctx:NativeVKContext, cb:Int, pipe:Int) {}
	@:hlNative("sdl_vk", "cmd_bind_vertex_buffer") static function cmdBindVertexBuffer_native(ctx:NativeVKContext, cb:Int, binding:Int, bid:Int, offset:Int) {}
	@:hlNative("sdl_vk", "cmd_bind_index_buffer") static function cmdBindIndexBuffer_native(ctx:NativeVKContext, cb:Int, bid:Int, offset:Int, idxType:Int) {}
	@:hlNative("sdl_vk", "cmd_set_viewport") static function cmdSetViewport_native(ctx:NativeVKContext, cb:Int, x:Single, y:Single, w:Single, h:Single) {}
	@:hlNative("sdl_vk", "cmd_set_scissor") static function cmdSetScissor_native(ctx:NativeVKContext, cb:Int, x:Int, y:Int, w:Int, h:Int) {}
	@:hlNative("sdl_vk", "cmd_draw") static function cmdDraw_native(ctx:NativeVKContext, cb:Int, vc:Int, ic:Int, fv:Int, fi:Int) {}
	@:hlNative("sdl_vk", "cmd_draw_indexed") static function cmdDrawIndexed_native(ctx:NativeVKContext, cb:Int, idxCount:Int, instCount:Int, firstIdx:Int, vertOff:Int, firstInst:Int) {}
	@:hlNative("sdl_vk", "cmd_draw_indexed_indirect") static function cmdDrawIndexedIndirect_native(ctx:NativeVKContext, cb:Int, bufId:Int, offset:Int, drawCount:Int, stride:Int) {}
	@:hlNative("sdl_vk", "cmd_draw_indirect_count") static function cmdDrawIndirectCount_native(ctx:NativeVKContext, cb:Int, bufId:Int, offset:Int, countBufId:Int, countOffset:Int, maxDrawCount:Int, stride:Int) {}
	@:hlNative("sdl_vk", "create_query_pool") static function createQueryPool_native(ctx:NativeVKContext, queryType:Int, queryCount:Int):Int return -1;
	@:hlNative("sdl_vk", "destroy_query_pool") static function destroyQueryPool_native(ctx:NativeVKContext, qpId:Int) {}
	@:hlNative("sdl_vk", "cmd_begin_query") static function cmdBeginQuery_native(ctx:NativeVKContext, cb:Int, qpId:Int, queryIdx:Int, flags:Int) {}
	@:hlNative("sdl_vk", "cmd_end_query") static function cmdEndQuery_native(ctx:NativeVKContext, cb:Int, qpId:Int, queryIdx:Int) {}
	@:hlNative("sdl_vk", "cmd_reset_query_pool") static function cmdResetQueryPool_native(ctx:NativeVKContext, cb:Int, qpId:Int, firstQuery:Int, queryCount:Int) {}
	@:hlNative("sdl_vk", "get_query_pool_results") static function getQueryPoolResults_native(ctx:NativeVKContext, qpId:Int, firstQuery:Int, queryCount:Int, data:hl.Bytes, dataSize:Int, stride:Int, flags:Int):Bool return false;
	@:hlNative("sdl_vk", "cmd_write_timestamp") static function cmdWriteTimestamp_native(ctx:NativeVKContext, cb:Int, qpId:Int, queryIdx:Int, stage:Int) {}
	@:hlNative("sdl_vk", "cmd_copy_buffer") static function cmdCopyBuffer_native(ctx:NativeVKContext, cb:Int, srcBufId:Int, dstBufId:Int, size:Int) {}
	@:hlNative("sdl_vk", "cmd_fill_buffer") static function cmdFillBuffer_native(ctx:NativeVKContext, cb:Int, bufId:Int, dstOffset:Int, size:Int, data:Int) {}
	@:hlNative("sdl_vk", "cmd_update_buffer") static function cmdUpdateBuffer_native(ctx:NativeVKContext, cb:Int, bufId:Int, offset:Int, data:hl.Bytes, size:Int) {}
	@:hlNative("sdl_vk", "cmd_clear_attachments") static function cmdClearAttachments_native(ctx:NativeVKContext, cb:Int, attachmentCount:Int, r:Single, g:Single, b:Single, a:Single) {}
	@:hlNative("sdl_vk", "get_buffer_device_address") static function getBufferDeviceAddress_native(ctx:NativeVKContext, bufId:Int):hl.I64 return 0;
	@:hlNative("sdl_vk", "cmd_set_line_width") static function cmdSetLineWidth_native(ctx:NativeVKContext, cb:Int, lineWidth:Single) {}
	@:hlNative("sdl_vk", "cmd_set_stencil_reference") static function cmdSetStencilReference_native(ctx:NativeVKContext, cb:Int, faceMask:Int, reference:Int) {}
	@:hlNative("sdl_vk", "cmd_set_cull_mode") static function cmdSetCullMode_native(ctx:NativeVKContext, cb:Int, cullMode:Int) {}
	@:hlNative("sdl_vk", "cmd_set_front_face") static function cmdSetFrontFace_native(ctx:NativeVKContext, cb:Int, frontFace:Int) {}
	@:hlNative("sdl_vk", "cmd_set_primitive_topology") static function cmdSetPrimitiveTopology_native(ctx:NativeVKContext, cb:Int, topo:Int) {}
	@:hlNative("sdl_vk", "cmd_set_depth_test_enable") static function cmdSetDepthTestEnable_native(ctx:NativeVKContext, cb:Int, enable:Bool) {}
	@:hlNative("sdl_vk", "cmd_set_depth_write_enable") static function cmdSetDepthWriteEnable_native(ctx:NativeVKContext, cb:Int, enable:Bool) {}
	@:hlNative("sdl_vk", "cmd_set_depth_compare_op") static function cmdSetDepthCompareOp_native(ctx:NativeVKContext, cb:Int, compareOp:Int) {}
	@:hlNative("sdl_vk", "cmd_set_stencil_test_enable") static function cmdSetStencilTestEnable_native(ctx:NativeVKContext, cb:Int, enable:Bool) {}
	@:hlNative("sdl_vk", "cmd_set_depth_bias_enable") static function cmdSetDepthBiasEnable_native(ctx:NativeVKContext, cb:Int, enable:Bool) {}
	@:hlNative("sdl_vk", "cmd_set_rasterizer_discard_enable") static function cmdSetRasterizerDiscardEnable_native(ctx:NativeVKContext, cb:Int, enable:Bool) {}
	@:hlNative("sdl_vk", "check_descriptor_set_layout_support") static function checkDescriptorSetLayoutSupport_native(ctx:NativeVKContext, bindingCount:Int, bindingType:Int):Bool return true;
	@:hlNative("sdl_vk", "host_reset_query_pool") static function hostResetQueryPool_native(ctx:NativeVKContext, qpId:Int, firstQuery:Int, queryCount:Int) {}
	@:hlNative("sdl_vk", "cmd_push_constants2") static function cmdPushConstants2_native(ctx:NativeVKContext, cb:Int, layout:Int, stageFlags:Int, offset:Int, size:Int, data:hl.Bytes) {}
	@:hlNative("sdl_vk", "cmd_copy_image") static function cmdCopyImage_native(ctx:NativeVKContext, cb:Int, srcId:Int, dstId:Int, srcLayout:Int, dstLayout:Int) {}
	@:hlNative("sdl_vk", "cmd_copy_image_to_buffer") static function cmdCopyImageToBuffer_native(ctx:NativeVKContext, cb:Int, imgId:Int, layout:Int, bufId:Int) {}
	@:hlNative("sdl_vk", "cmd_clear_depth_stencil") static function cmdClearDepthStencil_native(ctx:NativeVKContext, cb:Int, imgId:Int, layout:Int, depth:Single, stencil:Int, aspects:Int) {}
	@:hlNative("sdl_vk", "cmd_set_blend_constants") static function cmdSetBlendConstants_native(ctx:NativeVKContext, cb:Int, r:Single, g:Single, b:Single, a:Single) {}
	@:hlNative("sdl_vk", "create_event") static function createEvent_native(ctx:NativeVKContext):Int return -1;
	@:hlNative("sdl_vk", "destroy_event") static function destroyEvent_native(ctx:NativeVKContext, evtId:Int) {}
	@:hlNative("sdl_vk", "cmd_set_event") static function cmdSetEvent_native(ctx:NativeVKContext, cb:Int, evtId:Int, stage:Int) {}
	@:hlNative("sdl_vk", "cmd_wait_events") static function cmdWaitEvents_native(ctx:NativeVKContext, cb:Int, evtId:Int, srcStage:Int, dstStage:Int) {}
	@:hlNative("sdl_vk", "flush_memory") static function flushMemory_native(ctx:NativeVKContext, bufId:Int) {}
	@:hlNative("sdl_vk", "invalidate_memory") static function invalidateMemory_native(ctx:NativeVKContext, bufId:Int) {}
	@:hlNative("sdl_vk", "bind_image_memory2") static function bindImageMemory2_native(ctx:NativeVKContext, imgId:Int, memId:Int) {}
	@:hlNative("sdl_vk", "cmd_set_polygon_mode") static function cmdSetPolygonMode_native(ctx:NativeVKContext, cb:Int, mode:Int) {}
	@:hlNative("sdl_vk", "cmd_set_primitive_restart_enable") static function cmdSetPrimitiveRestartEnable_native(ctx:NativeVKContext, cb:Int, enable:Bool) {}
	@:hlNative("sdl_vk", "cmd_set_rasterization_samples") static function cmdSetRasterizationSamples_native(ctx:NativeVKContext, cb:Int, samples:Int) {}
	@:hlNative("sdl_vk", "cmd_draw_indirect_byte_count") static function cmdDrawIndirectByteCount_native(ctx:NativeVKContext, cb:Int, bufId:Int, offset:Int, countBufId:Int, countOffset:Int, maxDrawCount:Int, stride:Int) {}
	@:hlNative("sdl_vk", "cmd_set_logic_op_enable") static function cmdSetLogicOpEnable_native(ctx:NativeVKContext, cb:Int, enable:Bool) {}
	@:hlNative("sdl_vk", "cmd_set_logic_op") static function cmdSetLogicOp_native(ctx:NativeVKContext, cb:Int, op:Int) {}
	@:hlNative("sdl_vk", "cmd_set_color_blend_enable") static function cmdSetColorBlendEnable_native(ctx:NativeVKContext, cb:Int, firstAtt:Int, count:Int, enable:Bool) {}
	@:hlNative("sdl_vk", "cmd_set_color_blend_equation") static function cmdSetColorBlendEquation_native(ctx:NativeVKContext, cb:Int, firstAtt:Int, count:Int, mode:Int, src:Int, dst:Int, alphaMode:Int, alphaSrc:Int, alphaDst:Int) {}
	@:hlNative("sdl_vk", "cmd_set_color_write_mask") static function cmdSetColorWriteMask_native(ctx:NativeVKContext, cb:Int, firstAtt:Int, count:Int, mask:Int) {}
	@:hlNative("sdl_vk", "cmd_set_depth_clamp_enable") static function cmdSetDepthClampEnable_native(ctx:NativeVKContext, cb:Int, enable:Bool) {}
	@:hlNative("sdl_vk", "cmd_set_provoking_vertex_mode") static function cmdSetProvokingVertexMode_native(ctx:NativeVKContext, cb:Int, mode:Int) {}
	@:hlNative("sdl_vk", "cmd_set_line_rasterization_mode") static function cmdSetLineRasterizationMode_native(ctx:NativeVKContext, cb:Int, mode:Int) {}
	@:hlNative("sdl_vk", "cmd_set_tessellation_domain_origin") static function cmdSetTessellationDomainOrigin_native(ctx:NativeVKContext, cb:Int, origin:Int) {}
	@:hlNative("sdl_vk", "cmd_copy_buffer2") static function cmdCopyBuffer2_native(ctx:NativeVKContext, cb:Int, srcId:Int, dstId:Int, size:Int) {}
	@:hlNative("sdl_vk", "cmd_copy_image2") static function cmdCopyImage2_native(ctx:NativeVKContext, cb:Int, srcId:Int, dstId:Int, srcLayout:Int, dstLayout:Int) {}
	@:hlNative("sdl_vk", "cmd_blit_image2") static function cmdBlitImage2_native(ctx:NativeVKContext, cb:Int, srcId:Int, dstId:Int, srcMip:Int, dstMip:Int) {}
	@:hlNative("sdl_vk", "set_debug_name") static function setDebugName_native(ctx:NativeVKContext, handle:Int, objType:Int, name:hl.Bytes) {}
	@:hlNative("sdl_vk", "cmd_begin_debug_label") static function cmdBeginDebugLabel_native(ctx:NativeVKContext, cb:Int, r:Single, g:Single, b:Single, a:Single, name:hl.Bytes) {}
	@:hlNative("sdl_vk", "cmd_end_debug_label") static function cmdEndDebugLabel_native(ctx:NativeVKContext, cb:Int) {}
	@:hlNative("sdl_vk", "cmd_reset_event") static function cmdResetEvent_native(ctx:NativeVKContext, cb:Int, evtId:Int, stage:Int) {}
	@:hlNative("sdl_vk", "get_event_status") static function getEventStatus_native(ctx:NativeVKContext, evtId:Int):Bool return false;
	@:hlNative("sdl_vk", "cmd_begin_conditional_rendering") static function cmdBeginConditionalRendering_native(ctx:NativeVKContext, cb:Int, bufId:Int, offset:Int, inverted:Bool) {}
	@:hlNative("sdl_vk", "cmd_end_conditional_rendering") static function cmdEndConditionalRendering_native(ctx:NativeVKContext, cb:Int) {}
	@:hlNative("sdl_vk", "cmd_set_alpha_to_one_enable") static function cmdSetAlphaToOneEnable_native(ctx:NativeVKContext, cb:Int, enable:Bool) {}
	@:hlNative("sdl_vk", "cmd_set_fragment_shading_rate") static function cmdSetFragmentShadingRate_native(ctx:NativeVKContext, cb:Int, sizeW:Int, sizeH:Int) {}
	@:hlNative("sdl_vk", "cmd_set_sample_locations") static function cmdSetSampleLocations_native(ctx:NativeVKContext, cb:Int, samples:Int) {}
	@:hlNative("sdl_vk", "create_descriptor_update_template") static function createDescriptorUpdateTemplate_native(ctx:NativeVKContext, dslId:Int, layout:Int, set:Int, bindingCount:Int):Int return -1;
	@:hlNative("sdl_vk", "destroy_descriptor_update_template") static function destroyDescriptorUpdateTemplate_native(ctx:NativeVKContext, id:Int) {}

	@:hlNative("sdl_vk", "cmd_push_constants") static function cmdPushConstants_native(ctx:NativeVKContext, cb:Int, layout:Int, stageFlags:Int, offset:Int, size:Int, data:hl.Bytes) {}
	@:hlNative("sdl_vk", "create_descriptor_set_layout") static function createDescriptorSetLayout_native(ctx:NativeVKContext, bindingCount:Int, bindingType:Int):Int return -1;
	@:hlNative("sdl_vk", "get_descriptor_set_layout_handle") static function getDescriptorSetLayoutHandle_native(ctx:NativeVKContext, dslId:Int):Int return 0;
	@:hlNative("sdl_vk", "allocate_descriptor_set") static function allocateDescriptorSet_native(ctx:NativeVKContext, dslId:Int):Int return 0;
	@:hlNative("sdl_vk", "update_descriptor_set_texture") static function updateDescriptorSetTexture_native(ctx:NativeVKContext, ds:Int, binding:Int, sampler:Int, view:Int) {}
	@:hlNative("sdl_vk", "update_descriptor_set_buffer") static function updateDescriptorSetBuffer_native(ctx:NativeVKContext, ds:Int, binding:Int, buf:Int, offset:Int, range:Int) {}
	@:hlNative("sdl_vk", "cmd_bind_descriptor_sets") static function cmdBindDescriptorSets_native(ctx:NativeVKContext, cb:Int, ds:Int, firstSet:Int, layout:Int) {}
	@:hlNative("sdl_vk", "destroy_descriptor_set_layout") static function destroyDescriptorSetLayout_native(ctx:NativeVKContext, dslId:Int) {}
	@:hlNative("sdl_vk", "cmd_blit_image") static function cmdBlitImage_native(ctx:NativeVKContext, cb:Int, srcId:Int, dstId:Int, srcMip:Int, dstMip:Int) {}
	@:hlNative("sdl_vk", "cmd_resolve_image") static function cmdResolveImage_native(ctx:NativeVKContext, cb:Int, srcId:Int, dstId:Int, srcMip:Int, dstMip:Int, srcLayer:Int, dstLayer:Int) {}
	@:hlNative("sdl_vk", "cmd_copy_buffer_to_image") static function cmdCopyBufferToImage_native(ctx:NativeVKContext, cb:Int, bufId:Int, imgId:Int, mipLevel:Int, arrayLayer:Int) {}
	@:hlNative("sdl_vk", "create_compute_pipeline") static function createComputePipeline_native(ctx:NativeVKContext, cs:Int, layout:Int):Int return -1;
	@:hlNative("sdl_vk", "cmd_bind_compute_pipeline") static function cmdBindComputePipeline_native(ctx:NativeVKContext, cb:Int, pipe:Int) {}
	@:hlNative("sdl_vk", "cmd_bind_compute_descriptor_sets") static function cmdBindComputeDescriptorSets_native(ctx:NativeVKContext, cb:Int, ds:Int, firstSet:Int, layout:Int) {}
	@:hlNative("sdl_vk", "compute_dispatch") static function cmdDispatchCompute_native(ctx:NativeVKContext, cb:Int, groupCountX:Int, groupCountY:Int, groupCountZ:Int) {}

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
