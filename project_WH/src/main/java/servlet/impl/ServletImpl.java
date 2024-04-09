package servlet.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.ognl.NumericTypes;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import servlet.dto.MapDTO;
import servlet.service.ServletService;

@Service("ServletService")
public class ServletImpl extends EgovAbstractServiceImpl implements ServletService{
	
	@Resource(name="ServletDAO")
	private ServletDAO dao;
	
	@Override
	public String addStringTest(String str) throws Exception {
		List<EgovMap> mediaType = dao.selectAll();
		return str + " -> testImpl ";
	}

	@Override
	public List<Map<String, Object>> sggSelect(String sggcd) {
		return dao.sggSelect(sggcd);
	}
	
	@Override
	public Map<String, BigDecimal> bum(String sggcd) {
		return dao.bum(sggcd);
	}

	@Override
	public Map<String, Object> sdView(String str) {
		return dao.sdView(str);
	}

	@Override
	public Map<String, Object> sggView(String sggName) {
		return dao.sggView(sggName);
	}

	@Override
	public List<Map<String, Object>> sdList() {
		return dao.sdList();
	}

	@Override
	public List<Map<String, Object>> sggList(String test) {
		return dao.sggList(test);
	}
	

	@Override
	public void fileUp(List<Map<String, Object>> list) {
		//MapDTO dto = new MapDTO();
		
		for (int i = 0; i < list.size(); i++) {
			//dto.setUse_date((String)list.get(i).get("use_date"));
			//dto.setSgg_cd((String)list.get(i).get("sgg_cd"));
			//dto.setBjd_cd((String)list.get(i).get("bjd_cd"));
			//dto.setUse_amount((NumericTypes)list.get(i).get("use_amount"));
			
			dao.fileUp(list.get(i));
		}

	}

	@Override
	public Map<String, Object> getCoordinate(Map<String, Object> coor) {
		return dao.getCoordinate(coor);		
	}

	@Override
	public List<Map<String, Object>> totalChart() {		
		return dao.totalChart();
	}

	@Override
	public List<Map<String, Object>> sdChart(String sdName) {
		return dao.sdChart(sdName);
	}

	@Override
	public List<Map<String, Object>> sggLegendE(String place) {
		return dao.sggLegendE(place);
	}

	@Override
	public List<Map<String, Object>> sggLegendN(String place) {
		return dao.sggLegendN(place);
	}

	@Override
	public List<Map<String, Object>> bjdLegendE(String place) {
		return dao.bjdLegendE(place);
	}

	@Override
	public List<Map<String, Object>> bjdLegendN(String place) {
		return dao.bjdLegendN(place);
	}

	@Override
	public void refreshData() {
		dao.refreshData();
	}
	
	
}
