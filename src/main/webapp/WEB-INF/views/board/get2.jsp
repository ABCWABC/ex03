<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<%@include file="/WEB-INF/views/include/header_info.jsp" %>

<body class="hold-transition skin-blue sidebar-mini">
  <div class="wrapper">

  <%@include file="/WEB-INF/views/include/header.jsp" %>
  <%@include file="/WEB-INF/views/include/left_menu.jsp" %>

  <div class="content-wrapper">
    <section class="content-header">
      <h1>Page Header<small>Optional description</small></h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Level</a></li>
        <li class="active">Here</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content container-fluid">
     <div class="row">
      <div class="col-md-12">   
       <div class="box box-primary">
        <div class="box-header with-border">
          <h3 class="box-title">Board Read Page</h3>
        </div>
        <!-- /.box-header -->
            
           <div class="box-body">
             <div class="form-group">
               <label for="bno">Bno</label>
               <input type="text" class="form-control" id="bno" name="bno" value="${board.bno }" readonly="readonly">
             </div>
             <div class="form-group">
               <label for="title">Title</label>
               <input type="text" class="form-control" id="title" name="title" value="${board.title }" readonly="readonly">
             </div>
             <div class="form-group">
               <label for="content">Text area</label>
               <textarea class="form-control" rows="3" id="content" name="content" readonly="readonly">${board.content }</textarea>
             </div>
             <div class="form-group">
               <label for="writer">Writer</label>
               <input type="text" class="form-control" id="writer" name="writer" value="${board.writer }" readonly="readonly">
             </div>
           </div>
           <!-- /.box-body -->

           <div class="box-footer">
             <button id="btnModify" type="button" data-bno="${board.bno }" class="btn btn-primary">Modify</button>
             <button id="btnList" type="button" class="btn btn-info">List</button>
             <form id="operForm" action="/board/modify" method="get">
               <input type="hidden" id="bno" name="bno" value='<c:out value="${ board.bno}" />'>
               <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum }" />'>
               <input type="hidden" name="amount" value='<c:out value="${cri.amount }" />'>
               <input type="hidden" name="type" value='<c:out value="${cri.type }" />'>
               <input type="hidden" name="keyword" value='<c:out value="${cri.keyword }" />'>
                 
             </form>

           </div>
       
       </div>
     </div>
  </div>
  
		<div class="row">
		  <div class="col-md-12">
		    <button type="button" id="btnReplyAdd" class="btn btn-primary">Reply Write</button>      
		  </div>
		</div>
		
		<!--댓글 출력-->
		<div class="row">
		  <div class="col-md-12">
		    <div id="replyList">
		      
		    </div>
		  </div>
		</div>
		
		<!--댓글 페이징 출력-->
		<div class="row" id="replyPaging">
		      
		</div>
		  
	  </div>
	</section>
	<!-- /.content -->
  </div>
  <!-- /.content-wrapper -->
		
  <!-- Main Footer (기타 footer태그밑에 소스포함)-->
  <%@include file="/WEB-INF/views/include/footer.jsp" %>
</div>
<!-- ./wrapper -->

<!-- REQUIRED JS SCRIPTS(with jquery) -->
<%@include file="/WEB-INF/views/include/plugin_js.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js"></script>
<script id="replyTemplate" type="text/x-handlebars-template">
  {{#each .}}
  <div class="modal-body">
      <div class="form-group">
        <label for="replyer" class="col-form-label rno"><b>No. <span class="reply-rno">{{rno}}</span></b></label>
        <input type="text" class="form-control" name="replyer" readonly value="{{replyer}}">
      </div>
      <div class="form-group">
        <label for="reply" class="col-form-label regdate">{{prettifyDate replydate}}</label>
        <textarea class="form-control" name="reply" readonly>{{reply}}</textarea>
      </div>
      <div class="form-group">
        <button type="button" class="btn btn-link btn-reply-modify">Modify</button>
        <button type="button" class="btn btn-link btn-reply-delete">Delete</button>
      </div>
  </div>
  {{/each}}
</script>

  // Handlebars 사용자정의 Helper : 댓글 작성일 밀리세컨드 데이타를 날짜포맷으로 변환하는 작업(2022/01/11)
  
<script>

  Handlebars.registerHelper("prettifyDate", function(timeValue){
    const date = new Date(timeValue);
    return date.getFullYear() + "/" + date.getMonth() + 1 + "/" + date.getDate();
  });
  
  //1)댓글목록출력함수
  // replyArr : 댓글데이타를 받을 파라미터 target : 댓글목록이 표시될 위치, templateObj : 템플릿을 참조하는 변수
  
  let printData = function (replyArr, target, templateObj) {

    let template = Handlebars.compile(templateObj.html());
    let html = template(replyArr); // 댓글 템플릿소스와 데이터가 바인딩되어 결합된 소스
    target.empty();
    target.append(html);
  }

  //2)댓글페이징기능함수
  // pageMaker : 페이징정보, target : 페이징이 출력될 위치.

  let printPaging = function(pageMaker, target){
	  
  	  let pageInfoStr = "<div class='col-md-12'><div class='dataTables_paginate paging_simple_numbers' id='example2_paginate'><ul class='pagination'>";

	  if(pageMaker.prev){
	    pageInfoStr += "<li class='paginate_button previous ";
		pageInfoStr += "id='example2_previous'><a href='" + (pageMaker.startPage - 1) + "'";
		pageInfoStr += " aria-controls='example2' data-dt-idx='0' tabindex='0'>Previous</a></li>";
	  }
	
	  for(let i=pageMaker.startPage; i<= pageMaker.endPage; i++){
	    let strClass = (pageMaker.cri.pageNum == i) ? 'active' : '';
	    pageInfoStr += "<li class='paginate_button " + strClass + "'><a href='" + i + "'>" + i + "</a></li>";
	  }
	
	  if(pageMaker.next){
	    pageInfoStr += "<li class='paginate_button next ";
		pageInfoStr += "id='example2_next'><a href='" + (pageMaker.endPage + 1) + "'";
		pageInfoStr += " aria-controls='example2' data-dt-idx='0' tabindex='0'>Next</a></li>";
	  }
  
  	  pageInfoStr += "</ul></div></div>";
  	  target.html(pageInfoStr);
  }

  //현재 게시물 번호
  let bno = <c:out value="${ board.bno}" />;
  let replyPage = 1;
    
  //현재 게시물번호에 해당하는 댓글목록 요청주소
  let url = "/replies/pages/" + bno + "/" + replyPage + ".json";
  getPage(url);

  function getPage(url){
	  
    // 스프링에서 json포맷의 댓글목록과 페이징정보를 받아오는 구문
    $.getJSON(url, function(data){

        // data -> data.list, data.pageMaker

        // 댓글목록 출력
        printData(data.list, $("#replyList"), $("#replyTemplate"));
        // 댓글페이징출력
        printPaging(data.pageMaker, $("#replyPaging"));
    });
  }

  $(document).ready(function(){

    let operForm = $("#operForm");

    //수정 버튼 클릭시 동작
    $("#btnModify").on("click", function(){
      operForm.submit();
    });

    //목록 버튼 클릭시 동작
    $("#btnList").on("click", function(){
      operForm.find("#bno").remove();
      operForm.attr("action", "/board/list");
      operForm.submit();
    });
    
	//페이지 번호 클릭시.
	$("#replyPaging").on("click", "li.paginate_button a", function(e){
	  e.preventDefault();
	  console.log("댓글 페이지번호 클릭");
	
	  replyPage = $(this).attr("href");
	  let url = "/replies/pages/" + bno + "/" + replyPage + ".json";
	  getPage(url);
	});

  $("#btnReplyAdd").on("click", function(){
    
    $("#replyer").val("");
    $("#reply").val("");

    $("button#btnReplyWrite").show();
    $("button#btnReplyModify").hide();


    $("h5#exampleModalLabel").html("Reply Add");
    $("#exampleModal").modal('show');
  });
  
  
  $("#btnReplyWrite").on("click", function(){

    $("h5#exampleModalLabel").html("Reply Add");     // 선택자 ID속성이 중복되지 않게 사용함

    let replyer = $("#replyer").val();  
    let reply = $("#reply").val();
    let str = JSON.stringify({bno:${board.bno}, replyer:replyer, reply:reply});

    console.log(str);

    $.ajax({
      type: 'post',
      url : '/replies/new',
      headers: { "Content-Type" : "application/json" , "X-HTTP-Method-Override" : "POST" },
      dataType: 'text',
      data: JSON.stringify({ bno:${board.bno}, replyer:replyer, reply:reply }),
      success: function(result){
    	  
        if(result == "success"){
          alert("댓글 데이타 삽입성공");
          $("#replyer").val("");
          $("#reply").val("");
          $("#exampleModal").modal('hide');
          replyPage = 1;
    
          //현재 게시물번호에 해당하는 댓글목록 요청주소
          url = "/replies/pages/" + bno + "/" + replyPage + ".json";
          getPage(url);
        }
        
      }
    });
    
  });

  $("#replyList").on("click", "button.btn-reply-modify", function(){

    let replyer   = $(this).parents("div.modal-body").find("input[name='replyer']").val();
    let rno       = $(this).parents("div.modal-body").find("span.reply-rno").text();
    let replydate = $(this).parents("div.modal-body").find("label.regdate").text();
    let reply     = $(this).parents("div.modal-body").find("textarea[name='reply']").val();

    console.log("replyer: " + replyer);
    console.log("rno: " + rno);
    console.log("replydate: " + replydate);
    console.log("reply: " + reply);

    // 수정 모달대화상자에 댓글내용을 화면에 보여줌
    $("h5#exampleModalLabel").html("Reply Modify - ");
    $("h5#exampleModalLabel").append("&nbsp;&nbsp;No. " + rno);
    
    $("#replyer").val(replyer);
    $("#reply").val(reply);
    $("#replybno").val(rno);

    $("button#btnReplyWrite").hide();
    $("button#btnReplyModify").show();
    
    $("#exampleModal").modal('show');
    
  });

  //댓글 수정대화상자에서 수정버튼 클릭시
  $("button#btnReplyModify").on("click", function(){
    
    $.ajax({
      type: 'put',
      url: '/replies/modify/' + $("#replybno").val(),
      headers: { "Content-Type" : "application/json" , "X-HTTP-Method-Override" : "PUT" },
      dataType: 'text',
      data: JSON.stringify({reply: $("#reply").val()}),
      success: function(result){
    	  
        if(result == "success"){
          alert("댓글 수정됨");

          $("#replyer").val("");
          $("#reply").val("");

          $("#exampleModal").modal('hide');

          //현재 게시물번호에 해당하는 댓글목록 요청주소
          url = "/replies/pages/" + bno + "/" + replyPage + ".json";
          getPage(url);
        }
        
      }
    });
    
  });

  //댓글목록에서 삭제버튼 클릭
  $("#replyList").on("click", "button.btn-reply-delete", function(){

    let rno = $(this).parents("div.modal-body").find("span.reply-rno").text();

    if(!confirm("댓글 " + rno + "번을 삭제하겠습니까?")) { return; }

    $.ajax({
      type: 'delete',
      url: '/replies/delete/' + rno,
      headers: { "Content-Type" : "application/json" , "X-HTTP-Method-Override" : "DELETE" },
      dataType:'text',
      success: function(result){
    	  
        if(result == "success"){
          alert("댓글삭제됨");

          $("#exampleModal").modal('hide');

          //현재 게시물번호에 해당하는 댓글목록 요청주소
          url = "/replies/pages/" + bno + "/" + replyPage + ".json";
          getPage(url);
        }
      }
    });
    
  });

});

</script>

<!-- Modal Dialog-->

<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Reply Add</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <form>
          <div class="form-group">
            <label for="replyer" class="col-form-label">replyer:</label>
            <input type="text" class="form-control" id="replyer" name="replyer">
            <input type="hidden" class="form-control" id="replybno" name="replyerbno">
          </div>
          <div class="form-group">
            <label for="reply" class="col-form-label">reply:</label>
            <textarea class="form-control" id="reply" name="reply"></textarea>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary" id="btnReplyWrite">write</button>
        <button type="button" class="btn btn-primary" id="btnReplyModify">modify</button>
      </div>
    </div>
  </div>
</div>

<!-- Modal Dialog-->

</body>
</html>
