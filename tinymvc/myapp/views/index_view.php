<?

   include("common_top.php");

?>


<div id="content" class="contextual-links-region">
  <div id="left-panel" style="float:left;width:450px;">
    <div id="login">
      <form method="get" action="/index.php/default/access">
	<label for="user">Username</label>
	<input type="text" name='user' /><br>
	<label for="password">Password</label>
	<input type="password" name='passwd' /><br>
	<input style="width:100px; margin-top:10px;"; type="submit" value="Login" id="login-button">
      </form>
      <form method="get" action="/index.php/default/register">
	<button style="width:100px; margin-top:10px;">Register</button>
      </form>
      <form method="get" action="/index.php/default/recover_password_init">
	<button style="width:100px; margin-top:10px;">Recover Password</button>
      </form>

     </div>
  </div>
  <div id="right-panel" style="min-height:300px;float:left;width:450px;border-left:1px solid #111111; padding-left:10px;">
    Login your first time to access your sensor board on your flyport
    Learn how to configure your flyport to send online data from sensors, from the wiki <a href="/index.php/default/help">Link to wiki for sending data</a>
  </div>
</div>



<!--<form method="post" action="/index.php/default/remote_update">
    <input type="text" name='user' /><br>
<input type="password" name='password' /><br>
<input type="apikey" name='apikey' /><br>
<input type="name" name='brightness' /><br>
<input type="name" name='humidity' /><br>
<input type="name" name='temperature' /><br>
<input type="submit" value="send" id="login-button">

</form>
-->
<?

include("common_bottom.php");

?>
