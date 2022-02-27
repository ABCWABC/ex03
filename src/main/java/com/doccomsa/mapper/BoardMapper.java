package com.doccomsa.mapper;

import java.util.List;

import com.doccomsa.domain.BoardVO;
import com.doccomsa.domain.Criteria;

// mapper interface를 기반으로 한 프록시 클래스 생성
public interface BoardMapper {

	//3)
	public void insert(BoardVO board);
	
	public List<BoardVO> getList();
	
	// 검색기능이 포함된 필드(type, keyword)가 사용하게 됨.
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	// 검색기능 포함
	public int getTotalCount(Criteria cri);
	
	
	public BoardVO get(Long bno);
	
	public void update(BoardVO board);
	
	public void delete(Long bno);
}
