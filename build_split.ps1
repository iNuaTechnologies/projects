$c = Get-Content "One Acre Fund/index.html" -Raw

function Process-Slide {
    param($rawSlide)
    
    $start = $rawSlide.IndexOf('<div class="cluster-title">')
    $end = $rawSlide.LastIndexOf('<!-- Logo Lockup -->')
    if ($end -eq -1) { $end = $rawSlide.LastIndexOf('<div class="logo-lockup"') }
    if ($end -eq -1) { $end = $rawSlide.Length }
    
    $content = $rawSlide.Substring($start, $end - $start)
    
    $content = $content -replace '<div class="cluster-title">', '<div class="cluster-title" style="transform: scale(0.85); transform-origin: top center; max-width: 380px; left: 50%; top: 2%;">'
    $content = $content -replace 'class="cluster-card"', 'class="cluster-card split-3way-card"'
    $content = $content -replace 'class="cluster-character"', 'class="cluster-character split-3way-char"'
    
    return $content
}

$nia_start = $c.IndexOf('<!-- Slide 13: Nia 2.0')
$nia_end = $c.IndexOf('</section>', $nia_start) + 10
$nia2 = $c.Substring($nia_start, $nia_end - $nia_start)

$chris_start = $c.IndexOf('<!-- Slide 15: Chris 2.0')
$chris_end = $c.IndexOf('</section>', $chris_start) + 10
$chris2 = $c.Substring($chris_start, $chris_end - $chris_start)

$nuru_start = $c.IndexOf('<!-- Slide 16: Nuru 2.0')
$nuru_end = $c.IndexOf('</section>', $nuru_start) + 10
$nuru2 = $c.Substring($nuru_start, $nuru_end - $nuru_start)

$nia_processed = Process-Slide $nia2
$chris_processed = Process-Slide $chris2
$nuru_processed = Process-Slide $nuru2

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

# Important: Delete from end to start so indices don't shift!
$c = $c.Remove($nuru_start, $nuru_end - $nuru_start)
$c = $c.Remove($chris_start, $chris_end - $chris_start)
$c = $c.Remove($nia_start, $nia_end - $nia_start)
$c = $c.Insert($nia_start, $new_slide)

Set-Content "One Acre Fund/index.html" $c -NoNewline
Write-Host "Success"
