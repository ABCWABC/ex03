package com.doccomsa.service;

import java.util.List;

import com.doccomsa.domain.BoardVO;
import com.doccomsa.domain.Criteria;

public interface BoardService {

	public void register(BoardVO vo);
	
	public List<BoardVO> getList();
	
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	// 검색기능 포함.
	public int getTotalCount(Criteria cri);
	
	public BoardVO get(Long bno);
	
	public void modify(BoardVO board);
	
	public void delete(Long bno);
	
}
