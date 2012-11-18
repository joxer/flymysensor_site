<? include("common_top.php"); ?>

<h3>Insert install settings</h3>

<form action="install">
<label for="type">type</label>
<input type="text" name="type"/>

<label for="host">host</label>
<input type="text" name="host"/>

<label for="name">name</label>
<input type="text" name="name"/>

<label for="user">user</label>
<input type="text" name="user"/>

<label for="password">password</label>
<input type="text" name="password"/>
<br><br>
<input type="submit" value="save settings"/>

</form>

<? include("common_bottom.php"); ?>