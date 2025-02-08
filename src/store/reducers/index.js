import { combineReducers } from "redux";
import User from "./User";
import Home from "./Home";
import Header from "./Header";
import Common from "./Common";
import Developer from "./Developer";
import Question from "./Question";

const allReducers = combineReducers({
  user: User,
  home: Home,
  header: Header,
  common: Common,
  developer: Developer,
  question: Question
});
export default allReducers;
