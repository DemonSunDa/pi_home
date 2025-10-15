#!/usr/bin/env python3
from scapy.all import *
from scapy.layers.l2 import Ether
import pandas as pd
from datetime import datetime

def pcap_to_csv_simple(pcap_file, csv_file):
    """
    解析 pcap 文件，提取源MAC、目标MAC、type和payload
    """
    packets = rdpcap(pcap_file)
    
    csv_data = []
    
    for i, packet in enumerate(packets):
        # 提取以太网层信息
        if packet.haslayer(Ether):
            ether = packet[Ether]
            row = {
                'packet_number': i + 1,
                'timestamp': datetime.fromtimestamp(float(packet.time)).strftime('%Y-%m-%d %H:%M:%S.%f'),
                'src_mac': ether.src,
                'dst_mac': ether.dst,
                'ether_type': hex(ether.type),
                'ether_type_name': get_ethertype_name(ether.type),
                'payload_length': len(ether.payload) if ether.payload else 0,
                'frame_length': len(packet),
                'payload_hex': ether.payload.original.hex() if hasattr(ether.payload, 'original') else ''
            }
            print(ether.src, ether.dst, hex(ether.type))
        else:
            # 对于非以太网帧，使用原始数据
            row = {
                'packet_number': i + 1,
                'timestamp': datetime.fromtimestamp(float(packet.time)).strftime('%Y-%m-%d %H:%M:%S.%f'),
                'src_mac': '',
                'dst_mac': '',
                'ether_type': '',
                'ether_type_name': 'Unknown',
                'payload_length': len(packet),
                'frame_length': len(packet),
                'payload_hex': packet.original.hex() if hasattr(packet, 'original') else ''
            }
        
        csv_data.append(row)
    
    # 转换为 DataFrame 并保存为 CSV
    df = pd.DataFrame(csv_data)
    df.to_csv(csv_file, index=False)
    print(f"成功转换 {len(packets)} 个数据包到 {csv_file}")
    return df

def get_ethertype_name(ether_type):
    """获取 Ethernet Type 的名称"""
    ethertypes = {
        0x0800: 'IPv4',
        0x0806: 'ARP',
        0x0835: 'RARP',
        0x0842: 'Wake-on-LAN',
        0x0880: 'FieldX',
        0x22F0: 'AVTP',
        0x22F3: 'IETF TRILL',
        0x6003: 'DECnet',
        0x8035: 'RARP',
        0x809B: 'AppleTalk',
        0x80F3: 'AARP',
        0x8100: 'VLAN-tagged',
        0x8137: 'IPX',
        0x8204: 'QNX Qnet',
        0x86DD: 'IPv6',
        0x8808: 'Ethernet Flow Control',
        0x8809: 'Slow Protocols',
        0x8819: 'CobraNet',
        0x8847: 'MPLS unicast',
        0x8848: 'MPLS multicast',
        0x8863: 'PPPoE Discovery',
        0x8864: 'PPPoE Session',
        0x8870: 'Jumbo Frames',
        0x887B: 'HomePlug',
        0x888E: 'EAP over LAN',
        0x8892: 'PROFINET',
        0x889A: 'HyperSCSI',
        0x88A2: 'ATA over Ethernet',
        0x88A4: 'EtherCAT',
        0x88A8: 'Provider Bridging',
        0x88AB: 'Ethernet Powerlink',
        0x88CC: 'LLDP',
        0x88CD: 'SERCOS III',
        0x88E1: 'HomePlug AV',
        0x88E3: 'Media Redundancy',
        0x88E5: 'MAC Security',
        0x88E7: 'PTP over Ethernet',
        0x88F7: 'PRP',
        0x8902: 'IEEE 802.1ag',
        0x8906: 'Fibre Channel over Ethernet',
        0x8914: 'FCoE Initialization',
        0x8915: 'RDMA over Converged Ethernet',
        0x892F: 'TTEthernet',
        0x9000: 'Ethernet Configuration Testing'
    }
    return ethertypes.get(ether_type, f'Unknown (0x{ether_type:04x})')

def check_abb_pattern_basic(series):
    """
    检查序列是否符合 A-B-B-B 循环模式
    返回: (是否符合, 错误位置列表)
    """
    if len(series) < 4:
        return False, ["序列长度不足4，无法检查A-B-B-B模式"]
    
    errors = []
    pattern_length = 4  # A-B-B-B 模式长度
    
    for i in range(len(series) - 3):
        # 检查当前窗口是否符合 A-B-B-B 模式
        a = series.iloc[i]
        b1 = series.iloc[i + 1]
        b2 = series.iloc[i + 2]
        b3 = series.iloc[i + 3]
        
        # A 不能等于 B，且三个 B 应该相等
        if a == b1 or b1 != b2 or b2 != b3:
            errors.append(f"位置 {i}-{i+3}: {a}-{b1}-{b2}-{b3} 不符合 A-B-B-B 模式")
    
    is_valid = len(errors) == 0
    return is_valid, errors

# 使用示例
if __name__ == "__main__":
    df_original = pcap_to_csv_simple('capture1.pcap', 'simple_output.csv')
    df_filtered = df_original[(df_original['payload_length'] == 80) | (df_original['payload_length'] == 160)]
    with open('filtered_output.txt', 'w') as f:
        for index, row in df_filtered.iterrows():
            f.write(f"{row['packet_number']},{row['payload_length']}\n")
