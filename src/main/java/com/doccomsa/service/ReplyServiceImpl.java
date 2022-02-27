package com.doccomsa.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.doccomsa.domain.Criteria;
import com.doccomsa.domain.ReplyPageDTO;
import com.doccomsa.domain.ReplyVO;
import com.doccomsa.mapper.ReplyMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
@AllArgsConstructor
public class ReplyServiceImpl implements ReplyService {

	private ReplyMapper mapper;

	@Override
	public int register(ReplyVO vo) {
		log.info("register.... " + vo);
		return mapper.insert(vo);
	}
	@Override
	public List<ReplyVO> getList(Criteria cri, Long bno) {
		return mapper.getListWithPaging(cri, bno);
	}
	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bno) {
		return new ReplyPageDTO(mapper.getCountByBno(bno), mapper.getListWithPaging(cri, bno));
	}
	@Override
	public int modifyReply(ReplyVO vo) {
		return mapper.update(vo);
	}
	@Override
	public int deleteReply(Long rno) {
		return mapper.delete(rno);
	}
}
