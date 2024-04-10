package servlet.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import servlet.service.ServletService;
import servlet.util.Util;

@Controller
public class ServletController {
	
	@Autowired
	private Util util;
	
	@Resource(name = "ServletService")
	private ServletService servletService;

	/*
	@RequestMapping(value = "/main.do")
	public String mainTest(ModelMap model) throws Exception {
		System.out.println("sevController.java - mainTest()");
		
		String str = servletService.addStringTest("START! ");
		model.addAttribute("resultStr", str);
		
		return "main/main";
	}
	*/

	@RequestMapping(value = "/main.do")
	public String mainTest() throws Exception {		
		return "mapTest";
	}
		
	@RequestMapping("/maptest.do")
	public String mapTest(Model model) {
		
		List<Map<String, Object>> sdlist = servletService.sdList();
		model.addAttribute("sdlist", sdlist);
		
		List<Map<String, Object>> totalChart = servletService.totalChart();
		model.addAttribute("totalChart", totalChart);
		ObjectMapper mapper = new ObjectMapper();
		try {
			String sdChart = mapper.writeValueAsString(totalChart);
			sdChart = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(totalChart);
			System.out.println(sdChart);
			model.addAttribute("sdChart", sdChart);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		return "mapTest";
	}
	
	@PostMapping("/maptest.do")
	public @ResponseBody List<Map<String, Object>> mapTest(@RequestParam("test") String test) {
		List<Map<String, Object>> sgglist = servletService.sggList(test);		
		Map<String, Object> sdView = servletService.sdView(test);
		sgglist.add(sdView);
		return sgglist;
	}
		
	
	@PostMapping("/sggSelect.do")
	public @ResponseBody Map<String, Object> sggSelect(@RequestParam("sggName") String sggName){
		Map<String, Object> sggView = servletService.sggView(sggName);
		return sggView;
	}
	
	
	@PostMapping("/fileUp.do")
	public @ResponseBody String	fileUp(@RequestParam("upFile") MultipartFile upFile) throws IOException	{
		
		System.out.println(upFile.getName());
		System.out.println(upFile.getContentType());
		System.out.println(upFile.getSize());
		
		List<Map<String, Object>> list = new ArrayList<>();
		Map<String, Object> m;
		InputStreamReader isr =	new InputStreamReader(upFile.getInputStream());
		BufferedReader br = new BufferedReader(isr);
		String line = null;
		int maxSize = 5000;
		int fileSize = (int) upFile.getSize();
		
		while ((line =	br.readLine()) != null)	{
			m = new HashMap<String, Object>();
			String[] lineArr = line.split("\\|");
			m.put("use_date", lineArr[0]); 
			m.put("sgg_cd", lineArr[3]); 
			m.put("bjd_cd", lineArr[4]); 
			m.put("use_amount", lineArr[13]);	
			list.add(m);
			
			if(fileSize > maxSize) {
				if(list.size() == maxSize) {
					servletService.fileUp(list);
					list = new ArrayList<>();
				}				
			}
		}
		servletService.fileUp(list);
		servletService.refreshData();
				
		br.close();
		isr.close();
		
		return "redirect:/mapTest";
	}
		
	@GetMapping("/chart.do")
	public String chart (Model model) {
		List<Map<String, Object>> totalChart = servletService.totalChart();
		model.addAttribute("totalChart", totalChart);
		
		ObjectMapper mapper = new ObjectMapper();
		
		try {
			String sdChart = mapper.writeValueAsString(totalChart);
			sdChart = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(totalChart);
			model.addAttribute("sdChart", sdChart);
			
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		return "chart";
	}
	
	@PostMapping(value= "/chart.do", produces = "application/text; charset=UTF-8")
	public @ResponseBody String sidoChart(@RequestParam("sido") String sdName) {
		
		List<Map<String, Object>> sdChart = servletService.sdChart(sdName);
		
		ObjectMapper mapper = new ObjectMapper();
		
		String sggChart = "";
		
		try {
			sggChart = mapper.writeValueAsString(sdChart);
			sggChart = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(sggChart);
			System.out.println(sggChart);
			
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		return sggChart;
	}
	
	@PostMapping("/sggLegendTable.do")
	public @ResponseBody String sggLegendTable(@RequestParam("place") String place, @RequestParam("select") String select) {
		
		List<Map<String, Object>> sggLegend = new ArrayList<Map<String, Object>>();
		
		if (select.equals("1")) {
			sggLegend = servletService.sggLegendE(place);			
		} else if (select.equals("2")) {
			sggLegend = servletService.sggLegendN(place);
		}
		
		ObjectMapper mapper = new ObjectMapper();
		
		String sggChartLegend = "";
		
		try {
			sggChartLegend = mapper.writeValueAsString(sggLegend);
			sggChartLegend = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(sggLegend);
			System.out.println(sggChartLegend);
			
			
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		return sggChartLegend;
	}
	@PostMapping("/bjdLegendTable.do")
	public @ResponseBody String bjdLegendTable(@RequestParam("place") String place, @RequestParam("select") String select) {
		
		List<Map<String, Object>> bjdLegend = new ArrayList<Map<String, Object>>();
		
		if (select.equals("3")) {
			bjdLegend = servletService.bjdLegendE(place);			
		} else if (select.equals("4")) {
			bjdLegend = servletService.bjdLegendN(place);
		}
		
		ObjectMapper mapper = new ObjectMapper();
		
		String bjdChartLegend = "";
		
		try {
			bjdChartLegend = mapper.writeValueAsString(bjdLegend);
			bjdChartLegend = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(bjdLegend);
			System.out.println(bjdChartLegend);
			
			
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		return bjdChartLegend;
	}
}
