package servlet.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import servlet.impl.MapDAO;

@Service
public class MapService {
	
	@Autowired
	private MapDAO mapDAO;
	
	
}
