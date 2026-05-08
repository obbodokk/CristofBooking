import React from "react"
import Header,{Login,Register,About,Dashboard} from "./Headers"
import Search from "./Search"
import { BrowserRouter as Router, Routes, Route} from 'react-router-dom';
class App extends React.Component{
    render(){return(
        <div id="top">
            <Router>
            <Routes>

            <Route path="/" element={ <><Header/> <Search/></>}/>

            <Route path="/login" element={<Login/>}/>
            <Route path="/register" element={<Register/>}/>
            <Route path="/about" element={<About/>}/>
            <Route path="/dashboard" element={<Dashboard/>}/>
            </Routes>
            </Router>
        </div>
        
    )}
}
export default App