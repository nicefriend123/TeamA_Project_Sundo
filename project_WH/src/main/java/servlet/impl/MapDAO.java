package servlet.impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MapDAO {
	
	@Autowired
	SqlSession sqlSession;
	
	public List<Map<String, Object>> sdList() {

		return sqlSession.selectList("carbonMap.sdList");
	}

	public List<Map<String, Object>> sggList(String test) {
		return sqlSession.selectList("carbonMap.sggList", test);
	}
	
	
}
