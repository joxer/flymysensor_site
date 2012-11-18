<? include("common_top.php") ?>

<div id="content" class="contextual-links-region">

Learn how to configure your microcontroller to do an http request to this site to update values<br>

<div class="box-info-help">Configure Flyport</div>

<div class="info-text">

Download this two library <a href="https://github.com/joxer/HTTPicus">HTTPicus</a> and <a href="https://github.com/joxer/FlyMySensors">FlyMySensors</a> and add them yo your project through the <b>External lib</b> button.

Then include them in the project and do an HTTP requesto with your parameter like this:

<pre class="sh_c">
char* username = "dummy";
char* password = "dummy";
char* project = "greenhouse";
char* apikey = "123123123123123123123";
send_to_site(username,password,project,apikey,"value",0.1);
</pre>
</div>

<div class="box-info-help">Configure Generic Microcontroller</div>
<div class="info-text">
To upload values with a generic microcontroller you have to do an HTTP POST request to index.php/default/remote_request
The server will responde with an OK if the request gone well otherwise it respods with a bad auth if you do an error with authentication.
<pre>
POST /index.php/default/remote_update HTTP/1.1
Host: flymysensor.com
User-Agent: MyUserAgent
Content-Length: 123

user=help&password=help&project=Greenhouse&apikey=123123&brightness=11
</pre>


</div>
</div>
<? include("common_bottom.php") ?>