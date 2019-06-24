$(function(){

  $('.custom-file-input').on('change',function(){
    $(this).next('.custom-file-label').html($(this)[0].files[0].name);
  });
  //ファイルの取消
  $('.reset').click(function(){
    $(this).parent().prev().children('.custom-file-label').html('ファイル選択...');
    $('.custom-file-input').val('');
    $('.food_image').remove();
  });

  $('#upload_image_file').change(function(){
    //ファイルオブジェクトを取得する
    let file = $(this).prop('files')[0];
    //画像でない場合は処理終了
    if(file.type.indexOf("image") < 0){
      alert("画像ファイルを指定してください。");
      return false;
    }

    //アップロードした画像を設定する
    let reader = new FileReader();
    reader.onload = function(){
      $('.input-group').append('<img  class="food_image" style="width:100%;height:100%;margin:10px;" />');
      $(".food_image").attr("src", reader.result);
      $(".food_image").attr("title", file.name);
    }

    reader.readAsDataURL(file);

  });
});
