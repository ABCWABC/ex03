package com.doccomsa.mapper;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.doccomsa.domain.Criteria;
import com.doccomsa.domain.ReplyVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

/*
 * ReplyMapper인터페이스가 스프링 컨테이너에서 bean으로 정상동작이 되는 지 체크.
 * 
 */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/spring/root-context.xml"})
@Log4j
public class ReplyMapperTests {

	//테스트전 자신의 게시판테이블에 데이타를 확인하여, 참고한다.
	private Long[] bnoArr = {65536L, 65535L, 65534L, 65533L, 65532L};
	
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;
	
	@Test
	public void testMapper() {
		
		log.info(mapper);
	}
	
	@Test
	public void testCreate() {
		
		ReplyVO vo = null;
		for(int i=1; i<= 10; i++) {
			vo = new ReplyVO();
			// tbl_board테이블의 bno컬럼의 데이타를 참조.
			vo.setBno(bnoArr[i % 5]); // 나머지에 대한 경우의 수가 0,1,2,3,4 
			
			vo.setReply("댓글테스트 " + i);
			vo.setReplyer("replyer" + i);
			
			mapper.insert(vo);
		}
	}
	
	@Test
	public void testRead() {
		Long rno = 1L; // tbl_reply테이블의 rno컬럼(pk)의 값이 반드시 존재해야 한다.
		
		ReplyVO vo = mapper.read(rno);
		
		log.info(vo);
	}
	
	@Test
	public void testUpdate() {
		Long rno = 1L; 
		
		ReplyVO vo = mapper.read(rno);
		vo.setReply("Update Reply ");
		
		int count = mapper.update(vo);
		
		log.info("Update count: " + count);
		
	}
	
	@Test
	public void testDelete() {
		Long rno = 1L;
		int count = mapper.delete(rno);
		log.info("Delete count: " + count);
		
	}
	
	@Test
	public void testList() {
		
		Long bno = 65534L;
		
		Criteria cri = new Criteria(1, 2);
		
		List<ReplyVO> replies = mapper.getListWithPaging(cri, bno);
		
		// replies.forEach(reply -> log.info(reply));
		
		for(int i=0; i< replies.size(); i++) {
			log.info(replies.get(i));
		}
	}

}
