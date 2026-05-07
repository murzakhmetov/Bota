import { useState, useEffect, useRef } from 'react'
import './App.css'

function App() {
  const [ref, setRef] = useState(null)
  const [copied, setCopied] = useState(false)
  const [slide, setSlide] = useState(0)
  const [scrollY, setScrollY] = useState(0)
  const heroRef = useRef(null)

  const screens = [
    { src: '/screen1.jpeg', title: 'Карта путешествий' },
    { src: '/screen4.jpeg', title: 'Исследуй города' },
    { src: '/screen3.jpeg', title: 'Викторина' },
    { src: '/screen9.jpeg', title: 'AI Помощник' },
    { src: '/screen5.jpeg', title: 'Мини-игры' },
    { src: '/screen7.jpeg', title: 'Друзья' },
    { src: '/screen8.jpeg', title: 'Лидерборд' },
    { src: '/screen6.jpeg', title: 'Квесты' },
    { src: '/screen2.jpeg', title: 'Обучение' },
  ]

  useEffect(() => {
    const p = window.location.pathname
    const m = p.match(/\/invite\/(.+)/)
    if (m) setRef(m[1])
    const q = new URLSearchParams(window.location.search).get('ref')
    if (q) setRef(q)
  }, [])

  useEffect(() => {
    const t = setInterval(() => setSlide(p => (p + 1) % screens.length), 3500)
    return () => clearInterval(t)
  }, [])

  useEffect(() => {
    const onScroll = () => setScrollY(window.scrollY)
    window.addEventListener('scroll', onScroll, { passive: true })
    return () => window.removeEventListener('scroll', onScroll)
  }, [])

  const download = () => {
    const a = document.createElement('a')
    a.href = '/bota-app.apk'
    a.download = 'Bota.apk'
    a.click()
  }

  const copyLink = () => {
    navigator.clipboard.writeText('https://mybota.vercel.app?ref=BOTA2026')
    setCopied(true)
    setTimeout(() => setCopied(false), 2500)
  }

  return (
    <div className="landing">
      {/* Referral top bar */}
      {ref && (
        <div className="ref-bar">
          <span>Тебя пригласил друг!</span>
          <div className="ref-bar__code">Код: <b>{ref}</b></div>
          <button onClick={download}>Скачать</button>
        </div>
      )}

      {/* Sticky nav */}
      <header className={`hdr ${scrollY > 60 ? 'hdr--scrolled' : ''}`}>
        <div className="hdr__wrap">
          <a href="#" className="hdr__brand">
            <img src="/bota-glad.png" alt="" />
            <span>Бота</span>
          </a>
          <nav className="hdr__nav">
            <a href="#what">О приложении</a>
            <a href="#gallery">Скриншоты</a>
            <a href="#invite">Друзья</a>
          </nav>
          <button className="hdr__cta" onClick={download}>Скачать APK</button>
        </div>
      </header>

      {/* ===== HERO ===== */}
      <section className="hero" ref={heroRef}>
        {/* animated blobs */}
        <div className="hero__blobs">
          <div className="blob blob--1" />
          <div className="blob blob--2" />
          <div className="blob blob--3" />
        </div>

        <div className="hero__wrap">
          <div className="hero__left">
            <span className="hero__label">Для детей 7-11 лет</span>
            <h1>Путешествуй. Играй. Учись.</h1>
            <p>
              Бота - это образовательное приложение, где дети
              исследуют Казахстан через интерактивную карту,
              мини-игры и AI-помощника.
            </p>
            <div className="hero__btns">
              <button className="btn btn--fill" onClick={download}>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                Скачать для Android
              </button>
              <a href="#gallery" className="btn btn--ghost">Смотреть</a>
            </div>
            <div className="hero__metrics">
              <div><b>7+</b><span>мини-игр</span></div>
              <div><b>14</b><span>городов КЗ</span></div>
              <div><b>AI</b><span>помощник</span></div>
            </div>
          </div>

          <div className="hero__right">
            <div className="phone" style={{ transform: `perspective(1200px) rotateY(-8deg) rotateX(2deg) translateY(${scrollY * 0.06}px)` }}>
              <div className="phone__bezel">
                <div className="phone__island" />
                <img src={screens[slide].src} alt="" className="phone__img" key={slide} />
              </div>
            </div>
            {/* floating cards */}
            <div className="float-card float-card--1" style={{ transform: `translateY(${Math.sin(Date.now() / 2000) * 6}px)` }}>
              <img src="/coin.jpeg" alt="" />
              <span>+15 ботакоинов</span>
            </div>
            <div className="float-card float-card--2">
              <img src="/bota-coins.png" alt="" />
            </div>
          </div>
        </div>
      </section>

      {/* ===== WHAT ===== */}
      <section className="what" id="what">
        <div className="what__wrap">
          <span className="pill">Возможности</span>
          <h2>Что внутри приложения</h2>
          <div className="cards">
            {[
              { color: '#FF8C00', title: 'Карта Казахстана', text: 'Интерактивная карта с городами. Открывай новые локации, играя и проходя уровни', icon: <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polygon points="1 6 1 22 8 18 16 22 23 18 23 2 16 6 8 2 1 6"/><line x1="8" y1="2" x2="8" y2="18"/><line x1="16" y1="6" x2="16" y2="22"/></svg> },
              { color: '#4ECDC4', title: '7 мини-игр', text: 'Пазлы, память, слова, математика, квесты, викторины и ловля конфет', icon: <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><rect x="2" y="2" width="9" height="9" rx="1"/><rect x="13" y="2" width="9" height="9" rx="1"/><rect x="2" y="13" width="9" height="9" rx="1"/><rect x="13" y="13" width="9" height="9" rx="1"/></svg> },
              { color: '#9B59B6', title: 'AI-помощник Бота', text: 'Умный чат-бот, который отвечает на вопросы детей о Казахстане простым языком', icon: <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M12 2a7 7 0 017 7c0 2.38-1.19 4.47-3 5.74V17a2 2 0 01-2 2h-4a2 2 0 01-2-2v-2.26C6.19 13.47 5 11.38 5 9a7 7 0 017-7z"/><line x1="9" y1="22" x2="15" y2="22"/></svg> },
              { color: '#E74C3C', title: 'Ежедневные квесты', text: 'Каждый день новый квест: сначала изучи материал, потом пройди викторину', icon: <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M4 19.5A2.5 2.5 0 016.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 014 19.5v-15A2.5 2.5 0 016.5 2z"/></svg> },
              { color: '#3498DB', title: 'Исследуй на карте', text: 'Реальная спутниковая карта с 14 достопримечательностями и интересными фактами', icon: <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 014 10 15.3 15.3 0 01-4 10 15.3 15.3 0 01-4-10 15.3 15.3 0 014-10z"/></svg> },
              { color: '#F39C12', title: 'Друзья и лидерборд', text: 'Приглашай друзей, получай бонусы и соревнуйся в рейтинге по ботакоинам', icon: <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87"/><path d="M16 3.13a4 4 0 010 7.75"/></svg> },
            ].map((c, i) => (
              <div className="card" key={i} style={{ '--accent': c.color }}>
                <div className="card__icon">{c.icon}</div>
                <h3>{c.title}</h3>
                <p>{c.text}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ===== GALLERY ===== */}
      <section className="gallery" id="gallery">
        <div className="gallery__wrap">
          <span className="pill">Скриншоты</span>
          <h2>Как это выглядит</h2>
          <div className="gallery__track">
            {screens.map((s, i) => (
              <button
                className={`gallery__item ${slide === i ? 'gallery__item--active' : ''}`}
                key={i}
                onClick={() => setSlide(i)}
              >
                <div className="gallery__phone">
                  <img src={s.src} alt={s.title} />
                </div>
                <span>{s.title}</span>
              </button>
            ))}
          </div>
          <div className="gallery__dots">
            {screens.map((_, i) => (
              <button
                key={i}
                className={`gdot ${slide === i ? 'gdot--on' : ''}`}
                onClick={() => setSlide(i)}
              />
            ))}
          </div>
        </div>
      </section>

      {/* ===== INVITE ===== */}
      <section className="invite" id="invite">
        <div className="invite__wrap">
          <div className="invite__box">
            <div className="invite__visual">
              <img src="/bota-coins.png" alt="" className="invite__mascot" />
              <div className="invite__coin-stack">
                <img src="/coin.jpeg" alt="" />
                <img src="/coin.jpeg" alt="" />
                <img src="/coin.jpeg" alt="" />
              </div>
            </div>
            <div className="invite__info">
              <h2>Пригласи друга</h2>
              <p>Поделись ссылкой. Друг скачает приложение, введет твой код при регистрации, и вы оба получите по <b>15 ботакоинов</b>.</p>
              <div className="invite__steps">
                <div className="invite__step"><b>1</b><span>Скопируй ссылку</span></div>
                <div className="invite__step"><b>2</b><span>Друг скачает приложение</span></div>
                <div className="invite__step"><b>3</b><span>Друг вводит твой код</span></div>
                <div className="invite__step"><b>4</b><span>Оба получают 15 монет</span></div>
              </div>
              <div className="invite__link">
                <code>https://mybota.vercel.app?ref=BOTA2026</code>
                <button onClick={copyLink} className={copied ? 'copied' : ''}>
                  {copied ? 'Скопировано!' : 'Копировать'}
                </button>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ===== BOTTOM CTA ===== */}
      <section className="bottom-cta">
        <div className="bottom-cta__wrap">
          <img src="/bota-glad.png" alt="" className="bottom-cta__img" />
          <h2>Начни путешествие</h2>
          <p>Скачай приложение и отправляйся в путь по Казахстану вместе с Ботой</p>
          <button className="btn btn--fill btn--big" onClick={download}>Скачать для Android</button>
        </div>
      </section>

      {/* FOOTER */}
      <footer className="ft">
        <div className="ft__wrap">
          <div className="ft__brand">
            <img src="/bota-glad.png" alt="" />
            <span>Бота</span>
          </div>
          <p>Образовательное приложение для детей Казахстана</p>
        </div>
      </footer>
    </div>
  )
}

export default App
