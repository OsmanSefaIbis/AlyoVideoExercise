//
//  ViewController.swift
//  AlyoCase
//
//  Created by Sefa İbiş on 12.03.2024.
//
import UIKit
import AVFoundation

class VideoVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var stopPlayerButton: UIButton!
    
    private(set) var videoItems: [VideoItem] = []
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var stopFlag: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        requestVideoItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = playerView.bounds
    }
    
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        if stopFlag {
            stopCurrentPlayer()
        }
    }
    
    func setupTableView() {
        self.tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "VideoCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func stopCurrentPlayer() {
        if let currentPlayer = player, currentPlayer.rate != 0 && currentPlayer.error == nil {
            currentPlayer.pause()
            playerLayer?.removeFromSuperlayer()
        }
    }
    
    func startNewPlayer(with url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = playerView.bounds
        playerView.layer.addSublayer(playerLayer!)
        
        player?.play()
    }
    
    func requestVideoItems() {
        guard let url = URL(string: "https://ak1dtm.storage.googleapis.com/q/v1130.json") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let data = data {
                guard let decodedData = try? JSONDecoder().decode(VideoItems.self, from: data) else { return }
                self.videoItems = decodedData
                self.reloadTableView()
            }
        }
        task.resume()
    }
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
}

extension VideoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let unwrappedUrl = videoItems[indexPath.row].u else { return }
        guard let url = URL(string: unwrappedUrl) else { return }

        stopCurrentPlayer()
        startNewPlayer(with: url)
        stopFlag = true
    }

}

extension VideoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as? VideoCell
        else { fatalError("Fatal: @cellForRowAt")}
        cell.configure(with: videoItems[indexPath.row])
        return cell
    }
}
