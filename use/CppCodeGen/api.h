//--------------------------------------------------------------------
//  File api.h
//     Definition of the Novakod native API
//
//-------------------------------------------------------------------------
//  Copyright (c) 2002-2020 ICI Techno
//        All rights reserved
//-------------------------------------------------------------------------  */

class CFpgaApi;

typedef void ( *fctHandler_t ) ( CFpgaApi* pApi, void* pData );


class CFpgaApi
{
  public:
   
    virtual int Open( const char* SymFileName,
                      const char* EnvFileName ) = 0;

    virtual int SetParamsId( int id ) = 0; 

    virtual int LoadBinaryProg( const char* FileName, int chipNumber ) = 0;

    virtual void Close( ) = 0;

    virtual int InsertValue( int portNumber, int value ) = 0;
    virtual int InsertValue( int portNumber, __int64 value ) = 0;

    virtual int InsertEvent( int portNumber, int value ) = 0;
    virtual int InsertEvent( int portNumber, __int64 value ) = 0;

    virtual int InsertEvent( int portNumber ) = 0;

    virtual void SendStartEvent( ) = 0;

    virtual void SendEvents( ) = 0;

    virtual bool IsEventsRecv( ) = 0;

    virtual void WaitForEvents( ) = 0;

    virtual int GetPortName( int portNumber, const char*& portName ) = 0;

    virtual int GetPortNumberByName( const char* portName, 
                                     int& portNumber ) = 0;

    virtual int GetPortInfo( int portNumber, int& size, 
                             bool& isInput, bool& isActive ) = 0;

    virtual int GetPortValue( int portNumber, int& value ) = 0;
    virtual int GetPortValue( int portNumber, __int64& value ) = 0;

    virtual int GetPortEvent( int portNumber, bool& hasRecvEvent ) = 0;
    
    virtual int GetPortEvent( int portNumber, int& value,
                              bool& hasRecvEvent ) = 0;

    virtual int GetPortEvent( int portNumber, __int64& value,
                              bool& hasRecvEvent ) = 0;

    virtual int SendData( int numBank, DWORD address, DWORD length ) = 0;

    virtual int RecvData( int numBank, DWORD address, DWORD length ) = 0;

    virtual void AttachEventFct( fctHandler_t fctIntHandler, 
                                 void* data ) = 0;

    virtual void ReStartEventsReception( ) = 0;

    virtual int InitDMAParams( int numBank, int& sizeSend, int& sizeRecv, 
                               unsigned char*& sendBuffer,
                               unsigned char*& recvBuffer ) = 0;

    virtual bool GetErrorsMessages( const char*& message ) = 0;

    virtual ~CFpgaApi() = 0;

};


#ifdef __cplusplus
extern "C" 
{
#endif

CFpgaApi* _cdecl GetApiPtr( int numApi );

typedef CFpgaApi* ( _cdecl* GetApiPtr_t )( int numApi );

#ifdef __cplusplus 
}
#endif