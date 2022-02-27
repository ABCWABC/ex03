package com.doccomsa.web;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.doccomsa.domain.BoardVO;
import com.doccomsa.domain.Criteria;
import com.doccomsa.domain.PageDTO;
import com.doccomsa.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@RequestMapping("/board/*")  // /board 로 시작하는 주소는 BoardController클래스가 요청을 담당하는 의미.
@Controller
@AllArgsConstructor
public class BoardController {

	//private static final Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	// 생성자를 이용한 주입 : @AllArgsConstructor
	private BoardService service;
	
	
	//게시판 글쓰기 폼
	@GetMapping("/register")  //  /board/register 주소가 jsp파일명으로 사용한다.  "/WEB-INF/views/" + "/board/register" + ".jsp"
	public void register() {
		
	}
	
	// 게시판 글쓰기 저장
	@PostMapping("/register") // /board/register.  사용자가 입력한 데이터는 BoardVO클래스의 setter메서드를 통하여 필드에 저장된다.
	public String register(BoardVO board, RedirectAttributes rttr) {
		
		
		log.info("BoardVO.... " + board);
		//1)
		service.register(board);
		
		return "redirect:/board/list";
	}
	
	// Model 클래스 : 뷰(JSP)에 데이터를 전달하는 기능제공
	
	/*
	@GetMapping("/list")  //  /board/list
	public void list(Model model) {
		
		List<BoardVO> list = service.getList();
		model.addAttribute("list", list); // 첫번째 파라미터가 jsp에서 사용할 이름
	
	}
	*/
	
	
	// 2번째 파라미터 : Model model -> 스프링에서 자동으로 객체를 생성및대입
	// 1번째 파라미터 : Criteria cri
	//  1)/board/list 주소요청 Criteria클래스의 기본생성자 메서드가 자동호출   
	//  2)http://localhost:8888/board/list?pageNum=1&amount=20.  Criteria setter메서드가 작동됨.
	@GetMapping("/list")  
	public void list(Criteria cri, Model model) {
		
		log.info("list: " + cri);
		
		//1) list.jsp(뷰) 목록에 사용될 데이타
		List<BoardVO> list = service.getListWithPaging(cri); // pageNum=1, amount=10, 검색기능추가 type=검색종류, keyword=검색어
		model.addAttribute("list", list);
		
		//list.jsp(뷰) 의 페이징기능.   prev 1	2	3	4	5 next
		
		int total = service.getTotalCount(cri);
		
		log.info("total: " + total);
		
		//2) pageMaker : startPage, endPage, prev, next, cri(pageNum, amount, type, keyword) 필드를 jsp에서 사용할수가 있다.
		PageDTO pageDTO = new PageDTO(cri, total);
		model.addAttribute("pageMaker", pageDTO);

	}
	
	
	
	// 게시물읽기, 수정폼
	@GetMapping({"/get", "/modify"}) // 목록에서 선택한 게시물번호의 내용보기.  1)get.jsp: /board/get?bno=1  2)modify.jsp:  /board/modify?bno=1
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		
		log.info("get...  " + bno);
		
		BoardVO board = service.get(bno);
		model.addAttribute("board", board);
	}
	
	@PostMapping("/modify")  //   /board/modify  날짜데이터 포맷이 2022/01/05 일 경우는 정상. 2022-01-05 포맷은 에러발생. 오류 400 : 잘못된 요청문법
	public String modify(BoardVO board, Criteria cri, RedirectAttributes rttr) {
		
		
		log.info("modify: " + board);
		
		service.modify(board);
		/*
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		*/
		return "redirect:/board/list" + cri.getListLink();
	}
	
	@PostMapping("/remove")   //   /board/remove
	public String remove(@RequestParam("bno") Long bno, Criteria cri, RedirectAttributes rttr) {
		
		service.delete(bno);
		/*
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		*/
		//  http://localhost:8888/board/list?pageNum=7&amount=10&type=W&keyword=user2
		// "?pageNum=3&amount=20&type=TC&keyword=%EC%83%88%EB%A1%9C"
		return "redirect:/board/list" + cri.getListLink();
	}
}
