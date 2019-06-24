$(function(){
    var idNo = 1;

    $('button#addButton').on('click',function(){
        let tempTr = $('#templateForm');
        tempTr
            .clone(true)
            .removeAttr("id")
            .removeClass("NotDisp")
            .appendTo('#displayArea')
            .find('input[type="text"]')
            .prop("required",true);
        idNo++;
    });

    $('button[name=removeButton]').on('click',function(){
        let removeObj = $(this).closest('.form-row');
        if(removeObj.attr('id') != 'templateForm') {
            removeObj.next('*[name=errors]').remove();
            removeObj.remove();
        }
    });

});

