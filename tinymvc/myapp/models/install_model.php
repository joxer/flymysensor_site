<?php

class Install_Model extends TinyMVC_Model
{
  function install_database()
  {
  $path = getcwd()."/../tinymvc/sysfiles/configs/install_database.sql";
  $sql = file_get_contents($path);
 
 $this->db->pdo->query($sql);

  
} 
}

?>