-- this code is an heavily modified version of the code found here: https://pastebin.com/raw/8u8N1Nkw
/* Example of use :
-- Somewhere in your client-side code
hook.Add("HUDPaint", "DrawShadowsExample", function()
    -- Begin drawing shadows
    BSHADOWS.BeginShadow()

        -- Between BeginShadow and EndShadow, you perform your normal drawing operations
        -- For example, draw a rectangle that you want to cast a shadow
        draw.RoundedBox(10, 100, 100, 200, 100, Color(255, 0, 0, 255))

    -- Finish drawing shadows with the desired shadow properties
    -- Parameters: intensity, spread, blur, opacity, direction, distance, shadowOnly
    BSHADOWS.EndShadow(1, 3, 6, 200, -90, 5, false)
end)
*/

-- Check if BSHADOWS table exists, if not, create it
if not BSHADOWS then BSHADOWS = {} end

-- Initialize BSHADOWS components if they haven't been already
function BSHADOWS.Init()
    if BSHADOWS.initialized then return end

    -- Initialize render targets and materials
    BSHADOWS.RenderTargetOriginal = GetRenderTarget("bshadows_original", ScrW(), ScrH())
    BSHADOWS.RenderTargetShadow = GetRenderTarget("bshadows_shadow",  ScrW(), ScrH())
    BSHADOWS.ShadowMaterial = CreateMaterial("bshadows", "UnlitGeneric", {
        ["$translucent"] = 1,
        ["$vertexalpha"] = 1,
        ["$alpha"] = 1
    })
    BSHADOWS.ShadowMaterialGrayscale = CreateMaterial("bshadows_grayscale", "UnlitGeneric", {
        ["$translucent"] = 1,
        ["$vertexalpha"] = 1,
        ["$alpha"] = 1,
        ["$color"] = "0 0 0",
        ["$color2"] = "0 0 0"
    })

    BSHADOWS.initialized = true
end

-- Begins the shadow drawing process
function BSHADOWS.BeginShadow()
    BSHADOWS.Init()
    render.PushRenderTarget(BSHADOWS.RenderTargetOriginal)
    render.Clear(0, 0, 0, 0, true)
    cam.Start2D()
end

-- Helper function for blurring the render target
local function BlurRenderTarget(renderTarget, spread, blur)
    render.PushRenderTarget(renderTarget)
    render.OverrideAlphaWriteEnable(true, true)
    render.BlurRenderTarget(renderTarget, spread, spread, blur)
    render.OverrideAlphaWriteEnable(false, false)
    render.PopRenderTarget()
end

-- Ends the shadow drawing process and renders the shadow
function BSHADOWS.EndShadow(intensity, spread, blur, opacity, direction, distance, shadowOnly)
    BSHADOWS.Init()

    -- Set defaults for optional parameters
    local opacity = opacity or 255
    local direction = direction or 0
    local distance = distance or 0
    local shadowOnly = shadowOnly or false

    -- Copy the original render target to the shadow render target
    render.CopyRenderTargetToTexture(BSHADOWS.RenderTargetShadow)

    -- Blur the shadow render target if needed
    if blur > 0 then
        BlurRenderTarget(BSHADOWS.RenderTargetShadow, spread, blur)
    end

    render.PopRenderTarget()  -- End drawing to the original render target

    -- Set up shadow material with the blurred shadow render target
    BSHADOWS.ShadowMaterialGrayscale:SetTexture('$basetexture', BSHADOWS.RenderTargetShadow)
    BSHADOWS.ShadowMaterialGrayscale:SetFloat("$alpha", opacity / 255)

    -- Calculate shadow offsets based on direction and distance
    local xOffset = math.sin(math.rad(direction)) * distance
    local yOffset = math.cos(math.rad(direction)) * distance

    -- Draw the shadow
    render.SetMaterial(BSHADOWS.ShadowMaterialGrayscale)
    for i = 1, math.ceil(intensity) do
        render.DrawScreenQuadEx(xOffset, yOffset, ScrW(), ScrH())
    end

    -- Draw the original render target if not shadow-only
    if not shadowOnly then
        BSHADOWS.ShadowMaterial:SetTexture('$basetexture', BSHADOWS.RenderTargetOriginal)
        render.SetMaterial(BSHADOWS.ShadowMaterial)
        render.DrawScreenQuad()
    end

    cam.End2D()
end

