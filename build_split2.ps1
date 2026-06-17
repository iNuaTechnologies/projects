$c = Get-Content "One Acre Fund/index.html" -Raw

$nia2_match = [regex]::Match($c, '(?s)  <!-- Slide 13: Nia 2.0.*?  </section>')
$chris2_match = [regex]::Match($c, '(?s)  <!-- Slide 15: Chris 2.0.*?  </section>')
$nuru2_match = [regex]::Match($c, '(?s)  <!-- Slide 16: Nuru 2.0.*?  </section>')

function Process-Slide {
    param($rawSlide)
    
    # Strip wrappers
    $content = $rawSlide -replace '(?s)  <!-- Slide.*?<div class="cluster-title">', '<div class="cluster-title">'
    $content = $content -replace '(?s)  </section>', ''
    
    # Replace title
    $content = $content -replace '<div class="cluster-title">', '<div class="cluster-title" style="transform: scale(0.65); transform-origin: top center; max-width: 380px; left: 50%; top: 2%;">'
    
    # Add custom classes
    $content = $content -replace 'class="cluster-card"', 'class="cluster-card split-3way-card"'
    $content = $content -replace 'class="cluster-character"', 'class="cluster-character split-3way-char"'
    
    # Remove logo lockup
    $content = [regex]::Replace($content, '(?s)      <!-- Logo Lockup -->.*?</div>\s*</div>\s*', '</div>')
    
    return $content
}

$nia_processed = Process-Slide $nia2_match.Value
$chris_processed = Process-Slide $chris2_match.Value
$nuru_processed = Process-Slide $nuru2_match.Value

$new_slide = @"
  <!-- Split Slide: Nia 2.0, Chris 2.0, Nuru 2.0 -->
  <section class="cluster-slide split-3way">
    <div class="landscape-bg"></div>
    <div class="floor-curve"></div>

    <div style="display: flex; width: 100vw; height: 100vh; position: absolute; top: 0; left: 0;">
      <!-- COLUMN 1: NIA 2.0 -->
      <div style="flex: 1; position: relative;">
        $nia_processed
      </div>
      <div style="width: 2px; height: 75%; position: absolute; left: 33.33%; top: 12.5%; background: linear-gradient(to bottom, transparent, rgba(140, 65, 21, 0.4), transparent); z-index: 20;"></div>
      
      <!-- COLUMN 2: CHRIS 2.0 -->
      <div style="flex: 1; position: relative;">
        $chris_processed
      </div>
      <div style="width: 2px; height: 75%; position: absolute; left: 66.66%; top: 12.5%; background: linear-gradient(to bottom, transparent, rgba(140, 65, 21, 0.4), transparent); z-index: 20;"></div>

      <!-- COLUMN 3: NURU 2.0 -->
      <div style="flex: 1; position: relative;">
        $nuru_processed
      </div>
    </div>
  </section>
"@

$c = $c.Replace($nuru2_match.Value, "")
$c = $c.Replace($chris2_match.Value, "")
$c = $c.Replace($nia2_match.Value, $new_slide)

Set-Content "One Acre Fund/index.html" $c -NoNewline
Write-Host "Success!"
