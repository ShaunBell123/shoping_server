import './header.css';

import './header.css';

function Header() {
  return (
    <header>
      <nav className="nav-container">
        <ul className="nav-center">
          <li className='button-mid'>Dashboard</li>
          <li className='button-mid'>Home</li>
        </ul>
        <ul className="signin-login">
          <li>Log in</li>
          <li>Sign up</li>
        </ul>
      </nav>
    </header>
  );
}

export default Header;
