#ifndef _CGAMESTATE_
#define _CGAMESTATE_

/**
 * 클라이언트의 상태클래스의 베이스클래스
 *	- 처음 데이타 로딩과 화면 출력을 thread로 구현하려고 시도하여 멀티 쓰레드 코드가 주석처리되어
 *있다( 데이타 로딩과 DirectX의 문제로 포기 )
 *
 * @Author		최종진
 * @Date			2005/9/15
 */
class CGameState {
public:
    bool dev_ui_enabled;

public:
    CGameState(void);
    virtual ~CGameState(void);

    virtual int Update(bool bLostFocus) = 0;
    virtual int Enter(int iPrevStateID) = 0;
    virtual int Leave(int iNextStateID) = 0;

    virtual int ProcWndMsgInstant(unsigned uiMsg, WPARAM wParam, LPARAM lParam);

    virtual void ServerDisconnected();
    virtual void WorldServerDisconnected() {}
    virtual void AcceptedConnectLoginSvr() {}

    int GetStateID() { return m_iStateID; }

    virtual int ProcMouseInput(UINT uiMsg, WPARAM wParam, LPARAM lParam) = 0;
    virtual int ProcKeyboardInput(UINT uiMsg, WPARAM wParam, LPARAM lParam) = 0;

    void render_dev_ui();

    // Handlers
    virtual void on_loginserver_connected(){};
    virtual void on_login_succeeded(){};
    virtual void on_login_failed(int code){};
    virtual void on_charserver_connected(){};
    virtual void on_charserver_connect_failed(){};

protected:
    int m_iStateID;
};
#endif