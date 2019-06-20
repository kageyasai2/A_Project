$(function(){
  $('.kill_retios .kill_retio_graph').eq(0).show();
  $('.kill_retios .kill_retio_graph').eq(1).hide();

  $('.kill_button_group button').on('click',function(){
    $('.kill_retios .kill_retio_graph').hide();
    let index = $(this).index();
    $('.kill_retios .kill_retio_graph').eq(index).show();
  });

  $('.contributes .contribute_graph').eq(0).show();
  $('.contributes .contribute_graph').eq(1).hide();

  $('.contributes_button_group button').on('click',function(){
    $('.contributes .contribute_graph').hide();
    let index = $(this).index();
    $('.contributes .contribute_graph').eq(index).show();
  });

});