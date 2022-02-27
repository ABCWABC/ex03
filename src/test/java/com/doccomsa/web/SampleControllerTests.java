package com.doccomsa.web;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.doccomsa.domain.Ticket;
import com.google.gson.Gson;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

/*
 SampleController클래스의 ticket주소를 테스트목적
 Controller의 uri테스트 목적으로 필요한 내용 : @WebAppConfiguration,  MockMvc
  
 */


@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/spring/root-context.xml", "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
@Log4j
public class SampleControllerTests {

	
	@Setter(onMethod_ = @Autowired)
	private WebApplicationContext ctx;
	
	// MockMvc클래스 : 웹애플리케이션을 웹서버에 배포하지않고, 스프링mvc프로젝트의 기능을 테스트할수 있도록 그 기능을 제공한다.
	private MockMvc mockMvc;
	
	
	@Before // 클래스가 동작시 단 맨처음 1번만 실행되는기능
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}
	
	// SampleController Controller클래스의 /sample/ticket 주소를 테스트목적
	@Test 
	public void testConvert() throws Exception {
		
		Ticket ticket = new Ticket();
		ticket.setTno(123);
		ticket.setOwner("Admin");
		ticket.setGrade("AAA");
		
		// 객체를 JSON타입의 문자열로 변환하는 기능을 제공.
		String jsonStr = new Gson().toJson(ticket);
		
		log.info(jsonStr);
		
		// mockMvc객체를 통하여, 컨트롤러의 주소를 호출
		mockMvc.perform(post("/sample/ticket")
				.contentType(MediaType.APPLICATION_JSON)
				.content(jsonStr))
				.andExpect(status().is(200));
				
		
	}
	
	

}
