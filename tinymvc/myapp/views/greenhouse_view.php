<? include("common_top.php") ?>
<script>
$(document).ready(function(){
<? foreach($values as $value){ ?>
      update_serra_values("<?= $value['name'] ?>", <?=  $value['value'] ?>);
<? } ?>
})
</script>
<div id="content" class="contextual-links-region">
  <div id="left-panel" style="float:left;width:450px;">
  <div id="image-bonsai" style="position:relative;">
  <div  id="sun-image" class="infos-value-serra"></div>
  <div id="rain-image" class="infos-value-serra"></div>
  <div id="thermo-image" class="infos-value-serra"></div>
  <img src="/images/bonsai.png" />
<!--
  <div id="temperature" style="background-color:red;opacity:0.8;border:3px solid black; border-radius:5px;width:100px;height:30px; position:absolute; left:80px;top:50px;">Temperature</div>
  <div id="humidity" style="background-color:green;opacity:0.8;border:3px solid black; border-radius:5px;width:100px;height:30px; position:absolute; left:150px;top:190px;">Humidity</div>
  <div id="brightness" style="background-color:yellow;opacity:0.8;border:3px solid black; border-radius:5px;width:100px;height:30px; position:absolute; left:230px;top:120px;">Brightness</div>-->
     </div>
  </div>
  <div id="right-panel" style="min-height:300px;float:left;width:450px;border-left:1px solid #111111; padding-left:10px;">
      There's your bonsai. The values in the box are the ones reported by your flyport. On the left you can see 3 boxes. They correspond to brightness, humidity and temperature, if they are clear values are too much high and your bonsai could die.
 <? foreach($values as $value){ ?>

  <div class="serra-values"> <?= $value['name'] ?>: <?=  $value['value'] ?></div>
<? } ?>

   <div id="help-sensor">
   <div id="help-button">Click to see parameters for request</div>
   <div id="help-text">humidity<br>brightness<br>temperature</div>
  </div>

  </div>
 
  </div>
</div>


<? include("common_bottom.php") ?>