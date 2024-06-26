package kr.or.ddit.notice.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.NoticeVO;
import kr.or.ddit.vo.PageVO;

public interface INoticeService {

	public List<NoticeVO> getAllNotice();
	public NoticeVO getNotice(int no);
	public int deleteNotice(int no);
	public int updateHits(int num);
	public int updateNotice(NoticeVO noticeVO);
	public int insertNotice(NoticeVO vo);
	
}	//INoticeService 끝
