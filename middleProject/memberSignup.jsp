<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/signup.css">
    
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<%=request.getContextPath()%>/js/jquery.serializejson.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<script>
$(()=>{ 
	
// 		가입하기
	$('#joinbtn').on('click', function()
	{	
		vdata1=  $('#joinform').serialize();
		
		console.log(vdata1);
		 
		
	// 	서버로 보내기
		$.ajax
		({
			url : "<%=request.getContextPath()%>/member/signupMember.do",	
			data : vdata1,
			type : 'post',
			dataType : 'json',
			success : function(res)
			{
				//성공시 이동할 경로 지정
				$('#join').html(res.sw).css('color', 'red');
				window.location.href = '<%=request.getContextPath()%>/view/login_out/loginMain.jsp';
			},
			error : function(xhr)
			{
				alert("에러 상태 : " + xhr.status);				
			}
		});	
	});
	
	// id값 형식체크
	$('#id').on('keyup', function()
	{
		idvalue = $(this).val().trim();			// id입력시 빈공간 제거
		idPattern= /^[a-zA-Z0-9]{6,15}$/;		// id정규식 : 영문 숫자 조합으로 6~15글자
		
		if(!(idPattern.test(idvalue)))
		{
			// ID값이 정규식과 일치하지 않을 경우
			$('#spanid').html("다시 입력해주세요").css('color','red');
			$('#checkid').prop('disabled', true);		// checkid 활성화
		}
		else
		{
			$('#spanid').html("");
			$('#checkid').prop('disabled', false);		// checkid 비활성화
		}
	});
	
	// id 입력하기
	$('#checkid').on('click', function()
	{
		idvalue = $('#id').val().trim();
		
		// 입력 필드 비어있거나 공백인 경우 확인
		if(idvalue.length<1)
		{
			alert("ID를 입력하세요!");
			return false;
		}
		
		// 서버로 전송하기
		$.ajax
		({
			url :  "<%=request.getContextPath()%>/member/checkIdMember.do",
			data	: {"id" :idvalue},
			type	: 'get',
			dataType: 'json',
			error : function(xhr)
			{
	            console.error("에러 상태:", xhr.status);
	            console.error("에러 내용:", xhr.responseText); // 추가: 서버에서 반환한 에러 메시지 확인
	            alert("에러 상태 : " + xhr.status);
			},
			success : function(res)
			{
				$('#spanid').html(res.sw).css('color','red');	
			}
		});
	});
	
	// password
	$('#pass2').on('keyup', function()
	{
		let pass1 = $("#pass1").val();
		let pass2 = $("#pass2").val();
		
		// 비밀번호 재확인
		if(pass1 != "" || pass2 != "")
		{
			if(pass1 == pass2)
			{
				$("#spanpass").html('일치');
				$("#spanpass").css('color', 'green');
			} else
			{
				$("#spanpass").html('불일치');
				$("#spanpass").css('color', 'red');
			}
		}
	});

	// 이름 형식체크
	$('#name').on('keyup', function()
	{
		namevalue= $(this).val().trim();
		namePattern=/^[가-힇]{2,10}$/;
		
		if(!namePattern.test(namevalue))
		{
			$('#spanname').html('형식오류').css('color','red');
		}else
		{
			$('#spanname').html("");
		}
	});
	
	// 연락처 형식체크	
	$('#tel').on('keyup', function()
	{
		telvalue= $(this).val().trim();
		telPattern=/01[016789]-[^0][0-9]{2,3}-[0-9]{3,4}/;		// 연락처 정규화
		
		if(!telPattern.test(telvalue))
		{
			$('#spantel').html('핸드폰 번호를 확인 해주세요.').css('color','red');
		}else
		{
			$('#spantel').html("");
		}
	});

	// 도메인 입력
	$(document).ready(function()
	{
    	$('#domain-list').change(function()
		{
        	const selectedOption = $(this).val();
        	const domainInput = $('#domain-text');

			if (selectedOption !== "type" && selectedOption !== null)
			{
            	domainInput.val(selectedOption);
            	domainInput.prop('disabled', true);
        	} else
			{
            	domainInput.val('');
            	domainInput.prop('disabled', false);
        	}
    	});
    });
});

// 우편 API
function prod1() {
    	 
 	    var themeobj = {	    	   		
 	    }
	
	//실제 우편번호 API가 시작되는 코드
	new daum.Postcode
	({
	        	
//	 테마 설정값 호출
	theme: themeobj, 
	        	
	// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
    	oncomplete: function(data)
		{
		// 요청한 값들을 저장하는 변수
   		// 삭제해도 우편번호API에는 지장X
			var resultHTML = [];

            // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 나눈다.
            var roadAddr = data.roadAddress; // 도로명 주소 변수
            var extraRoadAddr = ''; // 참고 항목 변수

            // 법정동명이 있을 경우 추가한다. (법정리는 제외)
            // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
            if(data.bname !== '' && /[동|로|가]$/g.test(data.bname))
			{
				extraRoadAddr += data.bname;
            }
            
            // 건물명이 있고, 공동주택일 경우 추가한다.
            if(data.buildingName !== '' && data.apartment === 'Y')
			{
				extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
            }
            
            // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
            if(extraRoadAddr !== '')
			{
				extraRoadAddr = ' (' + extraRoadAddr + ')';
            }

            // 우편번호 검색해서 얻을 수 있는 data('key' , "value")를 <li>에 넣어서
            //	사용시 찾아보기 좋게 정리함
            for(var item in data)
			{
				resultHTML.push('<li><code class="data_key">'+item+'</code>: "'+data[item]+'"</li>');
            }
            
            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('postcode').value = data.zonecode;	// --> 우편번호 칸
            document.getElementById("roadAddress").value = roadAddr;	// --> 도로명 주소 칸
            
            // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
            if(roadAddr !== '')
			{
                document.getElementById("extraAddress").value = extraRoadAddr;
            } else 
			{
                document.getElementById("extraAddress").value = '';
            }
       }
    }).open();
}


</script>
<body>
	<div class="container">
		<form id="joinform" method="post" enctype="multipart/form-data"
			action="<%=request.getContextPath()%>/member/signupMember.do">
			<div class="header">
				<div>회원 가입을 위해</div>
                <div>정보를 입력해주세요.</div><br>
            </div>
            
            <div class="form-group">
                <label for="id">* 아이디</label>
                <table>
					<tr>
		            <td>
		                <input type="text" class="form-control" id="id" name="mem_id">
		            </td>
					<td>
		                <input type="button" id="checkid" value="중복검사" class="btn btn-primary">
					</td>
					</tr>
                </table>
		        <span id="spanid"></span>
            </div>
            
            <div class="form-group">
                <label for="pwd">* 비밀번호</label> 
                <input type="password" class="form-control" id="pass1" name="mem_pass">
            </div>
            
            <div class="form-group">
                <label for="pwd">* 비밀번호확인</label> 
                <input type="password" class="form-control" id="pass2">
            	<span id="spanpass"></span>
            </div>
            
            <div class="form-group">
                <label for="name">* 이름</label>
                <input type="text" class="form-control" id="name" name="mem_name">
                <span id="spanname"></span>
            </div>
            
            <div class="form-group">
                <label for="tel">* 휴대폰번호</label> 
                <input type="text" class="form-control" id="tel" name="mem_tel">
                <span id="spantel"></span>
            </div>
 
          <div class="form-group">
             <label for="mail">* 이메일</label>
             <div class="email-input-group">
                 <input type="text" class="form-control" id="mail" name="mem_mail">
                 <span id="at">@</span>
                 <input type="text" class="form-control" id="domain-text" >
                 <select class="box" id="domain-list" name="domain">
					<option value="type">직접입력</option>
					<option value="naver.com">naver.com</option>
                    <option value="daum.net">daum.net</option>
                    <option value="gmail.com">gmail.com</option>
                    <option value="kakao.com">kakao.com</option>
                    <option value="nate.com">nate.com</option>
                 </select>
             </div>
         </div>      

        <div class="form-group" style="display: inline-block;">
         	<label for="zip">* 우편번호</label>
            <input type="text" id="postcode" class="d_form mini" placeholder="우편번호">
		</div>
            <div style="display: inline-block;">
			<input type="button" onclick="prod1()" value="우편번호 찾기" class="d_btn"><br><br>
		</div>
        
        <div class="form-group">
			<label for="add1">* 주소</label> 
			<input type="text" id="roadAddress" class="d_form std" placeholder="도로명주소" name="roadAddress"><br><br>
			<input type="text" id="extraAddress" class="d_form" placeholder="참고항목" name="extraAddress"><br><br>
		</div>
		
		<div class="form-group">
			<label for="add2">* 상세주소</label> 
            <input type="text" id="detailAddress" class="d_form" placeholder="상세주소" name="detailAddress"><br><br>
		</div>
            <br>
		<button type="button" id="joinbtn" class="btn btn-primary">가입하기</button>
        <span id="join"></span> 
		</form>
    </div>
    
</body>
</html>