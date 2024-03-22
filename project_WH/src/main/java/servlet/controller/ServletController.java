package servlet.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import servlet.service.MapService;
import servlet.service.ServletService;

@Controller
public class ServletController {
	
	@Autowired
	private MapService mapService;		
	
	@Resource(name = "ServletService")
	private ServletService servletService;
	
	@RequestMapping(value = "/main.do")
	public String mainTest(ModelMap model) throws Exception {
		System.out.println("sevController.java - mainTest()");
		
		String str = servletService.addStringTest("START! ");
		model.addAttribute("resultStr", str);
		
		return "main/main";
	}
	
	@RequestMapping("/test.do")
	public String test() {
		return "test";
	}

	@RequestMapping("/testtwo.do")
	public String testTwo() {
		return "testTwo";
	}
	
	@RequestMapping("/maptest.do")
	public String mapTest(Model model) {
		
		List<Map<String, Object>> sdlist = mapService.sdList();
		model.addAttribute("sdlist", sdlist);
		
		return "mapTest";
	}
	
	@PostMapping("/maptest.do")
	public @ResponseBody List<Map<String, Object>> mapTest(@RequestParam("test") String test) {
		//System.out.println("선택 : " + test);
		
		List<Map<String, Object>> sgglist = mapService.sggList(test);		
		
		System.out.println(sgglist);
		return sgglist;
	}
	
}
