$c = Get-Content "One Acre Fund/index.html" -Raw

$nia2_match = [regex]::Match($c, '(?s)  <!-- Slide 13: Nia 2.0.*?</section>')
$chris2_match = [regex]::Match($c, '(?s)  <!-- Slide 15: Chris 2.0.*?</section>')
$nuru2_match = [regex]::Match($c, '(?s)  <!-- Slide 16: Nuru 2.0.*?</section>')

function Extract-Inner {
    param($rawSlide)
    $startStr = '<div class="cluster-container">'
    $start = $rawSlide.IndexOf($startStr) + $startStr.Length
    $end = $rawSlide.LastIndexOf('</div>', $rawSlide.IndexOf('</section>'))
    return $rawSlide.Substring($start, $end - $start)
}

$nia_inner = Extract-Inner $nia2_match.Value
$chris_inner = Extract-Inner $chris2_match.Value
$nuru_inner = Extract-Inner $nuru2_match.Value

$new_slide = @"
  <!-- Split Slide: Nia 2.0, Chris 2.0, Nuru 2.0 -->
  <section class="cluster-slide split-3way">
    <div class="landscape-bg"></div>
    <div class="floor-curve"></div>

    <div style="display: flex; width: 100vw; height: 100vh; position: absolute; top: 0; left: 0;">
      <!-- COLUMN 1: NIA 2.0 -->
      <div style="flex: 1; position: relative;">
        $nia_inner
      </div>
      <div style="width: 2px; height: 75%; position: absolute; left: 33.33%; top: 12.5%; background: linear-gradient(to bottom, transparent, rgba(140, 65, 21, 0.4), transparent); z-index: 20;"></div>
      
      <!-- COLUMN 2: CHRIS 2.0 -->
      <div style="flex: 1; position: relative;">
        $chris_inner
      </div>
      <div style="width: 2px; height: 75%; position: absolute; left: 66.66%; top: 12.5%; background: linear-gradient(to bottom, transparent, rgba(140, 65, 21, 0.4), transparent); z-index: 20;"></div>

      <!-- COLUMN 3: NURU 2.0 -->
      <div style="flex: 1; position: relative;">
        $nuru_inner
      </div>
    </div>
  </section>
"@

$c = $c.Replace($nuru2_match.Value, "")
$c = $c.Replace($chris2_match.Value, "")
$c = $c.Replace($nia2_match.Value, $new_slide)

Set-Content "One Acre Fund/index.html" $c -NoNewline
Write-Host "Success!"
