import { Link } from "react-router-dom";
import "./Header.css";

function Header() {
  return (
    <header>
      <nav className="nav-container">
        <ul className="nav-center">
          <li className='button-mid'><Link to="/dashboard">Dashboard</Link></li>
          <li className='button-mid'><Link to="/">Home</Link></li>
        </ul>
        <ul className="signin-login">
          <li><Link to="/login">Log in</Link></li>
          <li><Link to="/signup">Sign up</Link></li>
        </ul>
      </nav>
    </header>
  );
}

export default Header;
