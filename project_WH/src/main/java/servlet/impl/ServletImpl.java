package servlet.impl;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
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
		dao.fileUp(list);
	}
	
	
}
