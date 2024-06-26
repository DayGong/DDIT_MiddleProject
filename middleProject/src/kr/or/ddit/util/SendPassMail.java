package kr.or.ddit.util;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

public class SendPassMail {
	// 새로운 임시 비밀번호를 저장하는 변수
	private static String newPass = null;
	
	public static void sendMail(String memMail) throws Exception {
	
		// 실제 사용중인 이메일 계정(발신자용)
		final String userMail = "2398_@naver.com"; 	// SMTP 인증을 위한 메일 계정
		// 실제 사용중인 계정 비밀번호(발신자용
		final String userPassWord = "ddit123~"; 	// SMTP 인증을 위한 비밀번호
		final String fromName = "대덕 워리어즈"; 	// 발신자 이름 입력
		
		// 수신자용 이메일 계정(회원가입시 입력받은 이메일)
		// DB에 저장되어있는 이메일 받아와서 사용
		final String to = memMail; 			// 수신자 이메일 주소 입력
		
		// 수신받았을때의 이메일 제목
		final String subject = "안녕하세요~! 한밭지킴이 임시 비밀번호 입니다.";	// 이메일 제목 입력
	
		// 이메일 발신시 보낼 메세지( str : 임시비밀번호)
		final String body = "임시 비밀번호는 "+ getNewPass() +"입니다! :)";	// 이메일 내용 입력
	
		// 호스트주소 , 포트 번호 는 첨부한 이미지 참고 
		final String host = "smtp.naver.com"; 	// 이메일 SMTP 호스트 주소
		final int port = 587; 			// SMTP 포트 번호
		
		// SMTP 서버 설정을 위해 Properties 객체 생성
		Properties props = new Properties();
		props.put("mail.smtp.port", port); 	// SMTP 포트 설정
		props.put("mail.smtp.auth", "true"); 	// SMTP 인증 활성화
		
		Session session = Session.getDefaultInstance(props); 	// 시스템 기본 세션을 가져옴
		MimeMessage msg = new MimeMessage(session); 		// MIME 형식의 이메일 메시지 생성
		
		Transport transport = null;
	
		try {
			msg.setFrom(new InternetAddress(userMail, fromName)); 			// 발신자 설정
			msg.setRecipient(Message.RecipientType.TO, new InternetAddress(to));	// 수신자 설정
			msg.setSubject(subject); 						// 이메일 제목 설정
			msg.setText(body); 							// 이메일 내용 설정
			
			transport = session.getTransport(); 					// 전송 객체 생성
			transport.connect(host, userMail, userPassWord); 			// 호스트 및 인증 정보로 연결
			transport.sendMessage(msg, msg.getAllRecipients());	 		// 이메일 전송
			System.out.println("메일 전송 완료"); 					// 이메일 전송 성공 시 출력
		} catch (Exception ex) {
			ex.printStackTrace(); // 예외 발생 시 스택 트레이스 출력
			System.out.println("메일 전송 실패");
		}
	}
	
	// 새로운 임시 비밀번호 생성 메서드
	private static String getPassword() {
		// 임시비밀번호가 저장될 변수
		StringBuilder str = new StringBuilder();
		
		// 임시 비밀번호를 발급받기 위한 랜덤번호(0~9,A~Z 까지 추가하고 싶은 문자는 아래의 형식처럼 추가가능)
		char[] charSet = new char[]{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
		
		// 문자 배열 길이의 값을 랜덤으로 10개를 뽑아 구문을 작성함
		int idx = 0;
		for (int i = 0; i < 10; i++) {
			idx = (int) (charSet.length * Math.random());
			str.append(charSet[idx]);
		}
		
		newPass = str.toString(); // 생성된 임시 비밀번호를 변수에 저장
		return newPass;
	}
	
	// 저장된 임시 비밀번호를 가져오는 메서드
	public static String getNewPass() {
		if (newPass == null) {
			// 새로 생성된 임시 비밀번호가 없으면 생성하고 반환
			return getPassword();
		}
		return newPass;
	}
}
