<? include("common_top.php") ?>

Project name: <?= $project ?>

<? foreach($values as $proj){?>
   <p> <?= $proj['name'] ?>: <?= $proj['value']?></p>
<? }?>

<? include("common_bottom.php") ?>
