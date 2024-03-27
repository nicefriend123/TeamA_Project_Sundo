package servlet.dto;

import org.apache.ibatis.ognl.NumericTypes;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MapDTO {
	int interval, legend;
	String use_date, bjd_nm, bjd_cd, sgg_nm, sgg_cd, sd_nm, sd_cd;
	NumericTypes use_amount;
}
