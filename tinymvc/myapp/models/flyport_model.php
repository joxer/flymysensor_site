<?php
class Flyport_Model extends TinyMVC_Model{
 
 function get_flyports($api){
 
  $this->db->select('*'); // set selected columns
  $this->db->from('flyports');  // set from what table(s)
  $this->db->where('apikey',$api); // where foo='test'
  $this->db->query();
  $rows = array();
  while($row = $this->db->next()) {
      $rows[] = $row;
  }
  return $rows;
 }

 function update_values($api,$project,$values){
  foreach($values as $key=>$value){

    $this->db->where('apikey',$api);
     $this->db->where('project_name',$project);
     $this->db->where('name', $key);
     $this->db->update('data',array('value'=>$value, "last_access"=>date("d/m/Y")));

     }
 }

 function get_projects($api){

  return $this->db->query_all("select project_name from flyports where apikey='".$api."';");

 }

 function get_project_with_values($api,$project){

   return $this->db->query_all("select name,value from flyports,data where flyports.project_name='".$project."' and flyports.apikey='".$api."' and flyports.apikey = data.apikey and flyports.project_name = data.project_name ;");


 }

 function create_new_project($api,$proj){

 $values = $this->db->query_one("select project_name from flyports where apikey='".$api."';");
 if($values != null)
 	    return false;
 // I SHOULD CREATE A TEMPLATE SYSTEM MORE FLEXIBLE

 if($proj == "Greenhouse"){
  $this->db->insert('flyports',array('apikey'=>$api,'project_name'=>'Greenhouse'));
  $this->db->insert('data',array('apikey'=>$api,'project_name'=>'Greenhouse',"name" => "temperature", "value"=> 0));
  $this->db->insert('data',array('apikey'=>$api,'project_name'=>'Greenhouse',"name" => "humidity", "value" => 0));
  $this->db->insert('data',array('apikey'=>$api,'project_name'=>'Greenhouse',"name" => "brightness","value" => 0));
}
 
 return true;
}
    
}
?>