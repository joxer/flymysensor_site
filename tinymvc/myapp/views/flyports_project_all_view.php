<? include("common_top.php"); ?>

<div id="content" class="contextual-links-region">
  <div id="left-panel" style="float:left;width:450px;">
    <div id="api" style="font-size:16px;color: #EA5B0C;padding:15px;background-color:#353535;"><b>Your api key is:</b> <i>«<?= $apikey ?>»</i></div><br>

    <a href="register_new_project"><b>Register a new project</b></a><br>
<br>
<h3>My projects:</h3>
<? foreach( $projects as $proj){?>

   <?if($proj['project_name'] == "Greenhouse"){?>
         <a href="flyport_project?project_name=<?= $proj['project_name']?>"><img src="/images/serra.png"><span class="project-name"><?= $proj['project_name']?></span></a><br>
   <?   } ?>
<? } ?>

  </div>
  
  <div id="right-panel" style="min-height:300px;float:left;width:450px;border-left:1px solid #111111; padding-left:10px;">
    <p>On the left you can see the your api key. You can use it to submit new values for your projects through a POST request online. See at <a href="#">DevPicusSensorApi at the wiki</a> how to do it<br>
    Under "My projects" you can see the project you have created.
  </div>
</div>

<? include("common_bottom.php"); ?>

