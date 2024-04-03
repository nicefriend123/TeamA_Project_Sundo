package servlet.impl;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import servlet.dto.MapDTO;

@Repository("ServletDAO")
public class ServletDAO extends EgovComAbstractDAO {
	
	@Autowired
	private SqlSessionTemplate session;
	
	public List<EgovMap> selectAll() {
		return selectList("servlet.serVletTest");
	}

	public List<Map<String, Object>> sggSelect(String sggcd) {
		return selectList("carbonMap.sggSelect", sggcd);
	}

	public Map<String, BigDecimal> bum(String sggcd) {
		return selectOne("carbonMap.bum", sggcd);
	}
	
	public Map<String, Object> sdView(String sd_nm){
		return selectOne("carbonMap.sdView", sd_nm);
	}

	public Map<String, Object> sggView(String sggName) {
		return selectOne("carbonMap.sggView", sggName);
	}
	
	public List<Map<String, Object>> sdList() {
		return selectList("carbonMap.sdList");
	}
	
	public List<Map<String, Object>> sggList(String test) {
		return selectList("carbonMap.sggList", test);
	}

	public Object fileUp(Map<String, Object> map) {
		return insert("carbonMap.fileUp", map);
	}

	public Map<String, Object> getCoordinate(Map<String, Object> coor) {
		return selectOne("carbonMap.point", coor);
		
	}

	public List<Map<String, Object>> totalChart() {
		return selectList("carbonMap.totalChart");
	}
	

}
