package servlet.util;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.map.HashedMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import servlet.service.ServletService;

@Component
public class Util {
	
	@Autowired
	private ServletService servletService;
	
	public String key() {
		return "1C6740EE-D23E-3A90-8F40-1D342D80666C";
	}
	
	
	public List<Map<String, BigDecimal>> equalInterval(String sggcd) {
		
		//최대값, 최소값, 범례	
		Map<String, BigDecimal> data = servletService.bum(sggcd);
		
		BigDecimal max = new BigDecimal(String.valueOf(data.get("max")));
		BigDecimal min = new BigDecimal(String.valueOf(data.get("min")));
		BigDecimal interval = new BigDecimal(String.valueOf(data.get("interval")));
		
		List<Map<String, BigDecimal>> legend = new ArrayList();
		Map<String, BigDecimal> map;
		
		for (int i = 0; i < 5; i++) {
			BigDecimal rangeStart = data.get("min").add(interval.multiply(new BigDecimal(i)));
            BigDecimal rangeEnd = data.get("min").add(interval.multiply(new BigDecimal(i + 1)));
	   		map = new HashedMap();
    		map.put("start", rangeStart);
    		map.put("end", rangeEnd);
    		legend.add(map);
		};
		
		System.out.println("범주 : " + legend);	
		
		return legend;
	}

	
	public List<BigDecimal> naturalBreak(List<BigDecimal> data, int classes) {
		
		
		
		return null;
	}
	


	    public static List<Double> jenksNaturalBreaks(List<Double> data, int numClasses) {
	        // 데이터를 오름차순으로 정렬
	        Collections.sort(data);

	        // 초기값 설정
	        double[][] mat1 = new double[data.size() + 1][numClasses + 1];
	        double[][] mat2 = new double[data.size() + 1][numClasses + 1];
	        double[][] breaks = new double[data.size() + 1][numClasses + 1];
	        double[] lowerClassLimits = new double[numClasses + 1];
	        
	        // 첫 번째 열 초기화
	        for (int i = 1; i <= numClasses; i++) {
	            mat1[1][i] = 1;
	            mat2[1][i] = 0;
	            for (int j = 2; j <= data.size(); j++) {
	                mat2[j][i] = Double.MAX_VALUE;
	            }
	        }
	        
	        // 집합에 대한 구간의 총 편차 계산
	        double v = 0.0;
	        for (int l = 2; l <= data.size(); l++) {
	            double s1 = 0.0;
	            double s2 = 0.0;
	            double w = 0.0;
	            for (int m = 1; m <= l; m++) {
	                int lowerClassLimit = l - m + 1;
	                double val = data.get(lowerClassLimit - 1);

	                // 제곱 합 및 값 합
	                s2 += val * val;
	                s1 += val;
	                
	                // 데이터 수 증가
	                w++;
	                
	                // 오류 계산
	                v = s2 - (s1 * s1) / w;
	                int i4 = lowerClassLimit - 1;
	                if (i4 != 0) {
	                    for (int j = 2; j <= numClasses; j++) {
	                        if (mat2[l][j] >= (v + mat2[i4][j - 1])) {
	                            mat1[l][j] = lowerClassLimit;
	                            mat2[l][j] = v + mat2[i4][j - 1];
	                        }
	                    }
	                }
	            }
	            mat1[l][1] = 1;
	            mat2[l][1] = v;
	        }
	        
	        // 구간 지정
	        int k = data.size();
	        breaks[k][numClasses] = data.get(data.size() - 1);
	        for (int j = numClasses - 1; j >= 2; j--) {
	            int id = (int) (mat1[k][j]) - 2;
	            breaks[k][j] = data.get(id);
	            k = (int) (mat1[k][j] - 1);
	        }
	        
	        // 나머지 구간 지정
	        for (int j = 1; j <= numClasses - 1; j++) {
	            lowerClassLimits[j] = data.get(0);
	        }
	        for (int i = 1; i <= data.size(); i++) {
	            int classIdx = numClasses;
	            for (int j = numClasses - 1; j >= 1; j--) {
	                if (i >= breaks[i][j]) {
	                    classIdx = j;
	                    lowerClassLimits[j] = breaks[i][j];
	                    break;
	                }
	            }
	        }
	        
	        List<Double> classifiedData = new ArrayList<>();
	        for (int i = 0; i < data.size(); i++) {
	            for (int j = 1; j <= numClasses; j++) {
	                if (data.get(i) <= breaks[i + 1][j]) {
	                    classifiedData.add(lowerClassLimits[j]);
	                    break;
	                }
	            }
	        }
	        return classifiedData;
	    }
	    
	    public static void main(String[] args) {
	        // 테스트 데이터
	        List<Double> testData = new ArrayList<>();
	        testData.add(10.0);
	        testData.add(20.0);
	        testData.add(30.0);
	        testData.add(40.0);
	        testData.add(50.0);
	        testData.add(60.0);
	        testData.add(70.0);
	        testData.add(80.0);
	        testData.add(90.0);
	        testData.add(100.0);
	        
	        // 클래스 개수 설정
	        int numClasses = 5;
	        
	        // 데이터 분류
	        List<Double> classifiedData = jenksNaturalBreaks(testData, numClasses);
	        
	        // 분류된 데이터 출력
	        System.out.println("Classified Data:");
	        System.out.println(classifiedData);
	    }
	

	
}
