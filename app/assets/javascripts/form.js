window.onload = $(document).on('turbolinks:load',function(){
 $("#input-text").on("keyup", function() {
   let countNum = String($(this).val().length);
   
   if(countNum > 50000 || countNum < 50){
    $("#counter").text("現在 " + countNum + " 文字").addClass("jscount");
   }else{
    $("#counter").text("現在 " + countNum + " 文字").removeClass("jscount");
   }
 });
});

window.onload = $(document).on('turbolinks:load',function(){
 $("#input-texttwo").on("keyup", function() {
   let countNum = String($(this).val().length);
   
   if(countNum > 1000 || countNum == 0){
    $("#countertwo").text("現在 " + countNum + " 文字").addClass("jscount");
   }else{
    $("#countertwo").text("現在 " + countNum + " 文字").removeClass("jscount");
   }
 });
});

window.onload = $(document).on('turbolinks:load',function(){
 $("#input-textfour").on("keyup", function() {
   let countNum = String($(this).val().length);
   
   if(countNum > 50 || countNum == 0){
    $("#counterfour").text("現在 " + countNum + " 文字").addClass("jscount");
   }else{
    $("#counterfour").text("現在 " + countNum + " 文字").removeClass("jscount");
   }
 });
});

window.onload = $(document).on('turbolinks:load',function(){
 $("#input-textthree").on("keyup", function() {
   let countNum = String($(this).val().length);
   
   if(countNum > 500){
    $("#counter").text("現在 " + countNum + " 文字").addClass("jscount");
   }else{
    $("#counter").text("現在 " + countNum + " 文字").removeClass("jscount");
   }
 });
});

window.onload = $(document).on('turbolinks:load',function(){
 $("#comment").on("keyup", function() {
   let countNum = String($(this).val().length);
   
   if(countNum > 300 || countNum == 0){
    $("#counter").text("現在 " + countNum + " 文字").addClass("jscount");
   }else{
    $("#counter").text("現在 " + countNum + " 文字").removeClass("jscount");
   }
 });
});