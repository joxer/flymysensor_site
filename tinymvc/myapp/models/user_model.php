<?php
class User_Model extends TinyMVC_Model{
      
      function login($user,$password){

      return $this->db->query_one("select * from users where user='".$user."' and password='".md5($password)."';");
      
      }

      function apikey($user){

      return $this->db->query_one("select apikey from users where user='".$user."';");
      
      }

      
      function register($user,$email,$password){
      if($this->db->query_one("select * from users where user='".$user."' and email='".$email."';") == FALSE){
      	$this->db->insert('users',array('user'=>$user,'email' => $email,'password'=>md5($password),'apikey'=>md5($user."#".$email)));
	return 0;
	}
      else{
        return -1;
      }

      }
      
      function recover($email){
       $this->db->where('email',$email); // setup query conditions (optional)
       $password =  substr(str_shuffle(str_repeat('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',8)),0,8);
       $this->db->update('users',array('password'=>md5($password)));
       return $password;
      }

}
?>