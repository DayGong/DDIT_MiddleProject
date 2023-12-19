<%@page import="kr.or.ddit.vo.BoardVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  <%@ page isELIgnored="true" %>   
<%
BoardVO boardVO = (BoardVO) request.getAttribute("boardVO");
String check = (String) session.getAttribute("check");
String mem_id = (String) session.getAttribute("mem_id");
String path = request.getContextPath();
String ss = (check != null && check.equals("true")) ? "check" : "";
String boardMemId = boardVO.getMem_id();
 boolean isAdmin = (mem_id != null && mem_id.equals(boardMemId));

%>
   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 상세보기</title>
	<script type="text/javascript" src="<%= path %>/js/jquery-3.7.1.min.js"></script>
	<script type="text/javascript" src="<%= path %>/js/board.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
	crossorigin="anonymous"></script>
	<script type="text/javascript">
	var ss = '<%=ss %>';
	 
	 mypath='<%=request.getContextPath()%>';
	 vaction=  $(this).attr('name');
	 vidx= $(this).attr('idx');//글 번호
	 queryString = window.location.search;

   
	 urlParams = new URLSearchParams(queryString);

	 brdNo = urlParams.get('brd_no');
	 console.log(brdNo); // brd_no의 값 출력
	 
	 reply ={}; //필요할때마다 동적으로 속성과 메소드를 추가할수있다 댓글 저장시 사용 
	 $(document).ready(function(){
	       <% if (ss.equals("check") && isAdmin) { %>
	         $('.boardMineA').addClass('btn btn-primary').css('display', 'inline-block');
	     <% } %>
	     
	     <%  if(ss.equals("check")){ %>
	    	 $('#insertRe').css("display","block");
	    	 <% } %>
		     
	     ReplyListServer();
	     
	    	
	    		$(document).on('click','.action',function(){
	    			cate=$(this).attr('name');
	    			gthis=$(this);
	    			reply.brd_no=brdNo;
	    			reply.rpl_content= $('#retext').val().replace(/<br>/g, '\n').trim();
	    			
	    			reply.mem_id="<%=mem_id%>";
	
	    			if(cate=="replyInsert"){
	    				
	    				writeReply();
	    			    $('#retext').val(" ");
	    				
	    				
	    			}
	    			
	    	})

	     
	   });

	 ReplyListServer=function(){
			
		  $.ajax({
			url : `${mypath}/reply/replyList.do`,
			async : false,
			type : 'get',		
			data : {"bonum" : brdNo}, 
			success :function(res){
				rcode="";
				$.each(res,function(i,v){
					
					content=v.rpl_content;
					content=content.replaceAll(/\n/g,"<br>");

				rcode+= `
		               <div class="reply-body">
			            <div class='p12' >
			              <p class="p1">
			              &nbsp;&nbsp;&nbsp;&nbsp;작성자 : <span class="rwr">${v.rpl_name}</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;					                                  					              
			                    날짜 : <span class="rda">${v.rpl_date}</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			              
			              </p>
			              <p class="p2">`;
/* 
                       if( uvo !=null && uvo.mem_name == v.name ){
			          rcode+=`<input type="button" idx="${v.renum}" value="댓글수정" name="r_modify" class="action">
			                <input type="button" idx="${v.renum}" value="댓글삭제" name="r_delete" class="action">`;
			           } */

                   rcode +=`</p>
			                  </div>
			                   <p class="p3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${content}</p></div></div><hr>`;
		
	})  //반복 끝
	
	//출력
	    $(this).parents('.card').find('.reply-body').remove();
        $('.replytab').html(rcode);
            
			},
			error : function(xhr){
			   alert(xhr.status);	
			},
			dataType: 'json'
		})
		
	} 

	 
	</script>

</head>

<body>
    <div class="card-body">
      <div class="table-responsive"> 
       <button class="btn btn-primary" onclick="location.href='<%=request.getContextPath() %>/board/list.do'">목록으로</button>
      <table class="table" id="dataTable" width="100%"   cellspacing="0">
         <tr class="table-light">
         <td colspan="2"><%=boardVO.getBrd_title()%></td>
         </tr>
         <tr>
         <td colspan="2"><%=boardVO.getMem_id()%></td>
         </tr>
         <tr>
         <td><%=boardVO.getBrd_date()%></td>  <td>조회 <%=boardVO.getBrd_hits()%></td>
         </tr>
         <tr height = "300px">
         <td colspan="2"><%=boardVO.getBrd_content()%></td>
         </tr>
         
      <tr>
                    <% if (ss.equals("check") && isAdmin) { %>
                        <td colspan="2">
                            <button class="boardMineA" onclick="location.href='<%=request.getContextPath() %>/board/update.do?brd_no=<%=boardVO.getBrd_no() %>'">게시글 수정</button>
                            <button class="boardMineA" onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='./delete.do?brd_no=<%=boardVO.getBrd_no() %>'">게시글 삭제</button>
                        </td>
                    <% } %>
                </tr>
         
      </table>
   </div>
</div>
     <div id="insertRe" style="display:none"> 
       &nbsp;&nbsp;&nbsp;&nbsp;<textarea id="retext" style="width :500px;"> </textarea>
       &nbsp;&nbsp;<input type="button" class="action" name="replyInsert" value="댓글 작성" style="width:150px;"><br>
     </div>
	<div class="replytab"></div>
</div>
</body>
</html>