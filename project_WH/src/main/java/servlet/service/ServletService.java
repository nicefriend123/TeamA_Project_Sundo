package servlet.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import servlet.dto.MapDTO;

@Service
public interface ServletService {
	String addStringTest(String str) throws Exception;
	
	Map<String, Object> sdView(String str);
	
	List<Map<String, Object>> sggSelect(String sggcd);

	Map<String, BigDecimal> bum(String sggcd);

	Map<String, Object> sggView(String sggName);
	
	List<Map<String, Object>> sdList();

	List<Map<String, Object>> sggList(String test);

	void fileUp(List<Map<String, Object>> list);

	Map<String, Object> getCoordinate(Map<String, Object> coor);

	List<Map<String, Object>> totalChart();

	List<Map<String, Object>> sdChart(String sdName);

	List<Map<String, Object>> sggLegendE(String place);

	List<Map<String, Object>> sggLegendN(String place);

	List<Map<String, Object>> bjdLegendE(String place);

	List<Map<String, Object>> bjdLegendN(String place);
}
