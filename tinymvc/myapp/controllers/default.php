<?php

/**
 * default.php
 *
 * default application controller
 *
 * @package		TinyMVC
 * @author		Monte Ohrt
 */

class Default_Controller extends TinyMVC_Controller
{

  private $logged = false;
  private $logged_error = false;

  

  function index()
  {


       if(  isset($_GET['error']) && $_GET['error'] == "true"){
        $this->view->assign("error","error login");
	$this->logged_error = false;
       }
       else if(isset($_GET['registered']) == "new"){
       	     $this->view->assign("notice","login your first time");
       }

      $this->view->display('index_view');
  }

  function access(){

  $this->load->model("User_Model","user");
  $user =  $_GET['user'];
  $passwd = $_GET['passwd'];

  if($this->user->login($user,$passwd) == false){

  header('Location: /index.php/default/index?error=true');
  } 
  else{

  session_start();
  $_SESSION['logged'] = true;
  $_SESSION['apikey'] = $this->user->apikey($user);
  $_SESSION['apikey'] = $_SESSION['apikey']['apikey'];
  $_SESSION['username'] = $user;
   $this->logged = true;
     header('Location: /index.php/default/flyports_projects_all');	   
    }
  } 

  function flyports_projects_all(){

  $this->is_logged();


     $this->load->model("Flyport_Model","flyports");   	   
     $user_value = ($this->flyports->get_flyports($_SESSION['apikey']));


    $this->view->assign("apikey",$_SESSION['apikey']);
    $projects = $this->flyports->get_projects($_SESSION['apikey']);

    $this->view->assign("projects",$projects);

    $this->view->display("flyports_project_all_view");

  } 

  function remote_update(){
  
  $user=$_POST['user'];
  $passwd= $_POST['password'];
  $apikey = $_POST['apikey'];
  $project = $_POST['project'];
  
  unset($_POST['user']);
  unset($_POST['password']);
  unset($_POST['apikey']);
  unset($_POST['project']);
  
  $this->load->model("Flyport_Model","flyports");
  $this->load->model("User_Model","user");   	   
  
  if($this->user->login($user,$passwd) == FALSE){

  echo "BAD AUTH\r\n";

  }
  else{

    $this->flyports->update_values($apikey,$project,$_POST);
   echo "OK\r\n";
  }  

  }	   

  function register(){
  if(isset($_GET['error']) && $_GET['error'] == "already")
   	  $this->view->assign("error","already registered");

  $this->view->display('register_view');
  
  }

  function register_account(){
	  

  $this->load->model("User_Model","user");
  $user =  $_POST['user'];
  $email = $_POST['email'];
  $passwd = $_POST['passwd'];
  if($this->user->register($user,$email,$passwd) != 0){

    header('Location: /index.php/default/register?error=already');  
  }
  else{
  header('Location: /index.php/default/index?registered=new');  
  }
  
  }

  function recover_password_init(){

  $this->view->display('recover_password_init_view');
  }
  function recover_password(){

  $email = $_POST['email'];
  $this->load->model("User_Model","user");
  $password = $this->user->recover($email);

  $to = $email;
  $subject = "Password recover";
  $message = "Hello! This is your new password:".$password."\n";
  $from = "sensors@openpicus.com";
  $headers = "From:" . $from;
  mail($to,$subject,$message,$headers);
  

  $this->view->assign("notice","see in your mail for your new password");  
  $this->view->display('index_view');
  }

  function register_new_project(){
  $this->view->display('register_new_project_view');
   }

   function project_create(){
   $this->is_logged();

   $project=$_GET['project'];

   $this->load->model("Flyport_Model","flyport");
   if($this->flyport->create_new_project($_SESSION['apikey'],$project) == false){
   $this->view->assign("error","You have already registered this project");	   $this->flyports_projects_all();
   
   }else{
   header('Location: /index.php/default/flyports_projects_all');      
   }
   }

   function flyport_project(){
   
   $this->is_logged();
 
   $project = $_GET['project_name'];

   $this->load->model("Flyport_Model","flyport");
   $values = $this->flyport->get_project_with_values($_SESSION['apikey'],$project);   

   if($project == "Greenhouse"){

   $this->view->assign("project", $project);
   $this->view->assign("values", $values);
   $this->view->display('greenhouse_view');
   }
 }

 function logout(){

 session_start();
 $_SESSION['logged'] = false;
 $_SESSION['apikey'] = "";
 $_SESSION['username'] = "";
 
 $this->view->display("index_view");

 }

 private function is_logged(){

 if(!isset($_SESSION))session_start();

 if(!isset($_SESSION['username']) && !isset($_SESSION['apikey']) && !isset($_SESSION['logged']) || ( $_SESSION['username'] == "" && $_SESSION['logged'] == "" && $_SESSION['apikey'] == "")){

  	  header('Location: /index.php/default/index?error=true');
  
    
  }

  }	
 

 function help(){

$this->view->display("help_view"); 

 } 

}
 
?>
