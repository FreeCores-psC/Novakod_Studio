//--------------------------------------------------------------------
//  File amessages_api.h
//     Error messages for the Novakod native API functions
//
//-------------------------------------------------------------------------
//  Copyright (c) 2002-2020 ICI Techno
//        All rights reserved
//-------------------------------------------------------------------------  */

#ifndef _MESSAGES_API_H_
#define _MESSAGES_API_H_


#define IDS_NO_ERROR_OCCUR                             0
#define IDS_OPEN_ENV_ERROR                            -1

#define IDS_INVALID_PORT_NUMBER                     3400
#define IDS_INVALID_PORT_NAME                       3401
#define IDS_DMA_ERROR_TOO_MUCH_BANK                 3402
#define IDS_DMA_ERROR_ADDRESS_LENGTH_TOO_HIGH       3403
#define IDS_DMA_ERROR_SENDBUFF_LENGTH_TOO_HIGH      3404
#define IDS_DMA_ERROR_RECVBUFF_LENGTH_TOO_HIGH      3405
#define IDS_BINARY_PROGRAM_NOT_LOAD                 3406
#define IDS_BINARY_PROGRAM_NOT_OPEN                 3407
#define IDS_DMA_ERROR_NO_BANK_AVAILABLE             3408
#define IDS_DMA_TRANSFER_ERROR                      3409
#define IDS_CARD_NOT_FOUND                          3410




#define IIDS_OPEN_SYM_ERROR                      "Error while parsing the symbols file."

#define IIDS_INVALID_PORT_NUMBER                 "The port number %lu is invalid."
#define IIDS_INVALID_PORT_NAME                   "The port name %s is invalid."

#define IIDS_DMA_ERROR_TOO_MUCH_BANK             "The bank number selected is greater than the number of available bank."
#define IIDS_DMA_ERROR_NO_BANK_AVAILABLE         "No bank is available for DMA transfer."
#define IIDS_DMA_ERROR_ADDRESS_LENGTH_TOO_HIGH   "The value of address and length parameters will create an overflow."
#define IIDS_DMA_ERROR_SENDBUFF_LENGTH_TOO_HIGH  "The value of sizeSend parameters is greater than the bank size"
#define IIDS_DMA_ERROR_RECVBUFF_LENGTH_TOO_HIGH  "The value of sizeRecv parameters is greater than the bank size"
#define IIDS_BINARY_PROGRAM_NOT_LOAD             "The FPGA program could not be load."
#define IIDS_BINARY_PROGRAM_NOT_OPEN             "The FPGA program file could not be open."
#define IIDS_DMA_TRANSFER_ERROR                  "Problems occur while transferring data."
#define IIDS_CARD_NOT_FOUND                      "The FPGA card is not connected."


#endif // _MESSAGES_API_H_