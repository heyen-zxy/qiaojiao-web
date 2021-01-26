// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require activestorage
//= require bootstrap
//= require select2-full
//= require jquery.lazyload
//= require summernote/summernote-bs4.min
//= require app
//= require_tree .


// $.fn.datepicker.dates['zh-cn'] = {
//   days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"],
//   daysShort: ["日", "一", "二", "三", "四", "五", "六"],
//   daysMin: ["日", "一", "二", "三", "四", "五", "六"],
//   months: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
//   monthsShort: ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二"],
//   today: "今天",
//   clear: "清除",
//   format: "yyyy-mm-dd",
//   titleFormat: "yyyy年 MM", /* Leverages same syntax as 'format' */
//   weekStart: 0
// };
var initPage = function () {
  $(".modal").on("hidden.bs.modal", function() {
    $(this).removeData("bs.modal");
  });

  setTableColor()
  $("img").lazyload();

  $('[data-provider="summernote"]').each(function(){
    editor = this
    console.log()
    $(this).summernote({
      height: 600,
      callbacks: {
        onImageUpload: function(files) {
          sendFile(files[0], editor);
        }
      }
    })
  })


  textToImg();
  $('select').select2();
  $.fn.modal.Constructor.prototype.enforceFocus = function () { };
  // $('.todo-list').todoList({
  //   onCheck  : function () {
  //   },
  //   onUnCheck: function () {
  //   }
  // });
  // $('.datepicker').datepicker({
  //   autoclose: true,
  //   language: 'zh-cn'
  // });

};


function show_flash(type, message){
  $(".page_tips").fadeIn(function(){
    setTimeout(function(){
      $(".page_tips").fadeOut();
      $(".page_tips").html('');
    }, 3000);
  });
  $(".page_tips").append(
    '<div class="' + type +'"> <div class="inner">'+ message + '<i class="fa fa-close close-tips"></i> </div> </div>');
}

function textToImg() {
  var fontSize = 500;
  var fontWeight = 'bold';
  var canvases = document.getElementsByClassName('canvas');
  for (var i = 0; i < canvases.length; i++) {
    var canvas = canvases[i];
    canvas.width = 1000;
    canvas.height = 1000;
    var context = canvas.getContext('2d');
    context.fillStyle = '#F7F7F9';
    context.fillRect(0, 0, canvas.width, canvas.height);
    context.fillStyle = '#605CA8';
    context.font = fontWeight + ' ' + fontSize + 'px sans-serif';
    context.textAlign = 'center';
    context.textBaseline = "middle";

    var name = $(canvas).attr('first_name');
    context.fillText(name, fontSize, fontSize);
    $(canvas).siblings('img').attr('src', canvas.toDataURL("image/png"));
  }

}

// 在线预览office pdf
function show_file(e){
  var filename = $(e).attr('data-file-name');
  var url = $(e).attr('data-url');
  var ext = filename.split('.').pop().toLowerCase();
  // word ppt xls 使用微软在线编辑
  // pdf 使用
  $('#file-modal-label').text($(e).attr('data-file-name'));
  if(['docx', 'doc', 'ppt', 'pptx', 'xls', 'xlsx'].indexOf(ext) >= 0){
    $('#file-modal-body').html("<iframe src='https://view.officeapps.live.com/op/embed.aspx?src=" + url +"' width='100%' height='100%' frameborder='0'></iframe>");
  }else if(['pdf'].indexOf(ext) >= 0){
    // $('#file-modal-body').html("<iframe src='" + url + "' width='100%' height='100%' frameborder='1'>\n");
    $('#file-modal-body').html("<iframe src='/pdfjs-2.0.943-dist/web/viewer.html?file=" + url + "' width='100%' height='100%' frameborder='0' scrolling='no'></iframe>");
  }else if(['png', 'jpg', 'jpeg', 'gif', 'bmp'].indexOf(ext) >= 0){
    $('#file-modal-body').html("<div style='text-align:center;'><image style='max-width:90%' src='"+ url + "'></image></div>");
  }else{
    alert('该文件格式暂时不支持在线预览，点击确定后直接下载文件。');
    location.href = url;
    return;
  }
  $('#file-modal').modal();
}

function showSpinner() {
  $("#spinner").addClass("spinner");
}

function hideSpinner() {
  $("#spinner").removeClass("spinner");
}

function selectImage(e){
  if($(e).hasClass('selected')){
    $(e).removeClass('selected')
  }else{
    $(e).addClass('selected')
  }
}

function selectedImages(){
  var selectIds = []
  $('#select_attachments').html('');
  $('img.selected').each(function(e){
    selectIds.push($(this).attr('file_id'));
    $('#select_attachments').append('<div class="col-md-3"><img src="' + $(this).attr('src') + '" style="width: 100px; height:100px;" ></div>');
  });
  console.log(selectIds)
  $('#select_attachment_ids').val(selectIds);

  $('#file-modal').modal('hide')
}

function add_norm(){
  $('.norm-rows').append('<div class="row norm-row">\n' +
    '          <div class="col-md-4 form-group">\n' +
    '            <div class="input-group">\n' +
    '              <div class="input-group-addon required">\n' +
    '                规格名<abbr title="required">*</abbr>\n' +
    '              </div>\n' +
    '              <input type="text" name=\'new_norms[]\' class="form-control">\n' +
    '\n' +
    '            </div>\n' +
    '            <!-- /.input group -->\n' +
    '          </div>\n' +
    '\n' +
    '          <div class="col-md-4 form-group">\n' +
    '            <div class="input-group">\n' +
    '              <div class="input-group-addon required">\n' +
    '                价格<abbr title="required">*</abbr>\n' +
    '              </div>\n' +
    '              <input type="number" name=\'new_prices[]\' class="form-control">\n' +
    '            </div>\n' +
    '            <!-- /.input group -->\n' +
    '          </div>\n' +
    '          <div class="col-md-1 form-group">\n' +
    '            <div class="input-group">\n' +
    '              <a href=\'javascript:void(0)\' class="delete_norm" onclick="delete_norm(this)">删除</a>\n' +
    '            </div>\n' +
    '          </div>\n' +
    '        </div>')
}

function delete_norm(e){
  $(e).parents('.norm-row').remove()
}

function sendFile(file, editor) {
  data = new FormData();
  data.append("file", file);
  $.ajax({
    data: data,
    type: "POST",
    url: '/attachments/upload_file',
    cache: false,
    contentType: false,
    processData: false,
    success: function (data) {
      $(editor).summernote("insertImage",data['url'])
    }
  });
}

function setTableColor(){
  i = 0
  $('.box-body table tr').each(function(e){
    i += 1;
    $(this).addClass('odd')
  })
}

$(document).ready(initPage);



