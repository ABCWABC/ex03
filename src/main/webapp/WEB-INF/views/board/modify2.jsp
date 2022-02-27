<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<html>
<!-- css, js 파일포함 -->
<!-- 절대경로  /WEB-INF/views/include/header_info.jsp -->
<%@include file="/WEB-INF/views/include/header_info.jsp" %>
<!--
BODY TAG OPTIONS:
=================
Apply one or more of the following classes to get the
desired effect
|---------------------------------------------------------|
| SKINS         | skin-blue                               |
|               | skin-black                              |
|               | skin-purple                             |
|               | skin-yellow                             |
|               | skin-red                                |
|               | skin-green                              |
|---------------------------------------------------------|
|LAYOUT OPTIONS | fixed                                   |
|               | layout-boxed                            |
|               | layout-top-nav                          |
|               | sidebar-collapse                        |
|               | sidebar-mini                            |
|---------------------------------------------------------|
-->
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">

  <!-- Main Header -->
  <%@include file="/WEB-INF/views/include/header.jsp" %>
  <!-- Left side column. contains the logo and sidebar -->
  <%@include file="/WEB-INF/views/include/left_menu.jsp" %>

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        Page Header
        <small>Optional description</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Level</a></li>
        <li class="active">Here</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content container-fluid">

      <!--------------------------
        | 글쓰기 폼 | BoardVO클래스의 필드명을 참고.
        -------------------------->
     <div class="row">
      <div class="col-md-12">   
       <div class="box box-primary">
            <div class="box-header with-border">
              <h3 class="box-title">Board Modify Page</h3>
            </div>
            <!-- /.box-header -->
            <form id="modifyForm" method="post" action="/board/modify">
              <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum }" />'>
              <input type="hidden" name="amount" value='<c:out value="${cri.amount }" />'>
              <input type="hidden" name="type" value='<c:out value="${cri.type }" />'>
              <input type="hidden" name="keyword" value='<c:out value="${cri.keyword }" />'>
              
              <div class="box-body">
              <div class="form-group">
                  <label for="bno">Bno</label>
                  <input type="text" class="form-control" id="bno" name="bno" value="${board.bno }" readonly="readonly">
                </div>
                <div class="form-group">
                  <label for="title">Title</label>
                  <input type="text" class="form-control" id="title" name="title" value="${board.title }">
                </div>
                <div class="form-group">
                  <label for="content">Text area</label>
                  <textarea class="form-control" rows="3" id="content" name="content">${board.content }</textarea>
                </div>
                <div class="form-group">
                  <label for="writer">Writer</label>
                  <input type="text" class="form-control" id="writer" name="writer" value="${board.writer }" readonly="readonly">
                </div>
                <div class="form-group">
                  <label for="regdate">RegDate</label> <!-- pattern="yyyy-MM-dd"  날짜포맷이 에러가 발생된다.-->
                  <input type="text" class="form-control" id="regdate" name="regdate" value="<fmt:formatDate value="${board.regdate }" pattern="yyyy/MM/dd"/>" readonly="readonly">
                </div>
                <div class="form-group">
                  <label for="updatedDate">Update Date</label>
                  <input type="text" class="form-control" id="updatedDate" name="updatedDate" value="<fmt:formatDate value="${board.updatedDate }" pattern="yyyy/MM/dd"/>" readonly="readonly">
                </div>
             </div>
            
              <!-- /.box-body -->

              <div class="box-footer">
                <button id="btnModify" type="submit" class="btn btn-primary">Modify</button>
                <button id="btnRemove" type="button" class="btn btn-danger">Remove</button>
                <button id="btnList" type="button" class="btn btn-info">List</button>
              </div>
            </form>
          </div>
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

<script>

  $(document).ready(function(){

    let formObj = $("#modifyForm");

    //목록버튼 클릭시 동작
    $("#btnList").on("click", function(){

      formObj.attr("action", "/board/list");
      formObj.attr("method", "get");

      /* 리스트로 보내는 정보
      <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum }" />'>
      <input type="hidden" name="amount" value='<c:out value="${cri.amount }" />'>
      <input type="hidden" name="type" value='<c:out value="${cri.type }" />'>
      <input type="hidden" name="keyword" value='<c:out value="${cri.keyword }" />'>

      */

      let pageNumTag = $("input[name='pageNum']").clone();
      let amountTag = $("input[name='amount']").clone();
      let keywordTag = $("input[name='type']").clone();
      let typeTag = $("input[name='keyword']").clone();

      console.log(pageNumTag);
      console.log(amountTag);
      console.log(keywordTag);
      console.log(typeTag);

      formObj.empty(); // 폼의 모든 내용을 제거.

      formObj.append(pageNumTag);
      formObj.append(amountTag);
      formObj.append(keywordTag);
      formObj.append(typeTag);


      formObj.submit();
    });

    $("#btnRemove").on("click", function(){

      if(confirm("게시물을 삭제하겠습니까?")){
        formObj.attr("action", "/board/remove");
        formObj.submit();
      }
    });

  });

</script>
</body>
</html>
