/**
 * @author 2008
 * @datetime 2024/8/18 2:03
 * @className: AnalyzerRule
 */
import { BookSource } from '../../../database/entities/BookSource';

export interface IRuleAnalyzer {
  body:string  //请求内容
  bookSource:BookSource//书源
}

export class  RuleAnalyzerData {
  body:string = ''  //请求内容
  bookSource?:BookSource//书源
}

export class RuleAnalyzer {
  ruleAnalyzerData:RuleAnalyzerData = new RuleAnalyzerData()
  init(ruleAnalyzerData:RuleAnalyzerData){
    this.ruleAnalyzerData = ruleAnalyzerData
  }

  getElements(rule:string):ESObject{
    let result: ESObject = null
		return []
	}

  /**
   * 分解规则生成规则列表
   */
  splitSourceRule(ruleStr?:string,allInOne:boolean = false){

  }
}
