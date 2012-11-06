$(document).ready(function(){

    if($("#error").html() != ""){

	$("#error").css("display","block");
    }
    if($("#notice").html() != ""){

	$("#notice").css("display","block");
    }

    $("#help-button").click(function(){$("#help-text").toggle("slow")})

})

function update_serra_values(name,value){

    switch(name){
    case "temperature":
	if(value > 20){
	$("#thermo-image").css("opacity","1.0");
	}
	break;
    case "humidity":
	if(value > 400){
	$("#rain-image").css("opacity","1");
	}
	break;
    case "brightness":
	if(value > 10){
	$("#sun-image").css("opacity","1");
	}
	break;
    }
}