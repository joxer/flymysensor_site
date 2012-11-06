<?php

class Install_Controller extends TinyMVC_Controller
{

  function index(){
  $path = getcwd()."/../tinymvc/sysfiles/configs/config_database.php";	
  if(file_exists($path) == FALSE){
    $this->view->display('install_view');
    }
    else{
    $this->view->assign("error","system already installed");
    $this->view->display('index_view');	 

    }
  }

  function install(){

  $type= htmlentities($_GET['type']);
  $host= htmlentities($_GET['host']);
  $name= htmlentities($_GET['name']);
  $user= htmlentities($_GET['user']);
  $password= htmlentities($_GET['password']);
  $content = "<?php
  \$config['default']['plugin'] = 'TinyMVC_PDO'; // plugin for db access
  \$config['default']['type'] = '$type';      // connection type
  \$config['default']['host'] = '$host';  // db hostname
  \$config['default']['name'] = '$name';     // db name
  \$config['default']['user'] = '$user';     // db username
  \$config['default']['pass'] = '$password';     // db password
  \$config['default']['persistent'] = false;  // db connection persistence?

?>";
  
  $path = getcwd()."/../tinymvc/sysfiles/configs/config_database.php";
  if(file_exists($path) == FALSE){
  
    file_put_contents($path,$content,FILE_APPEND | LOCK_EX);

    $this->load->model("Install_Model","installer");

    $this->installer->install_database();

    $this->view->assign("notice","system installed!");
    $this->view->display('index_view');	 



  }
  else{
    $this->view->assign("notice","file already exist");
    $this->view->display('install_view');	 
  }
  }

}